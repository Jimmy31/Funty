import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/animal_families.dart';
import '../data/catalog_seed.dart' show digitWords;
import '../models/exercise.dart';
import '../models/question.dart';
import '../repositories/question_stats_repository.dart';
import '../services/adaptive_question_selector.dart';
import '../services/end_message_bank.dart';
import '../services/feedback_sound_service.dart';
import '../services/letter_presentation.dart';
import '../services/object_scatter.dart';
import '../services/question_selector.dart';
import '../services/reward_calculator.dart';
import '../services/vosk_recognition_service.dart';
import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../widgets/badge_icon.dart';
import '../widgets/answer_flash_overlay.dart';

enum _RunnerStatus { loading, playing, listening, revealed, finished, error }

/// Ce que le micro donne à voir à l'enfant (cf. PRD 6.2) : gris = rien
/// d'audible, rouge = du son capté mais aucun mot de la grammaire reconnu
/// ("[unk]" côté Vosk), vert = un mot reconnu.
enum _MicState { idle, unrecognized, recognized }

/// Mode de saisie choisi par l'enfant sur les exercices qui acceptent les
/// deux (cf. PRD 6.2) — bascule explicite plutôt que les deux entrées
/// actives en permanence.
enum _InputMode { vocal, tactile }

/// Réponse "hors grammaire" de Vosk : du son a été capté, mais il ne
/// correspond à aucun mot attendu.
const _voskUnknown = '[unk]';

/// Compare deux prononciations sans se laisser piéger par la casse, les
/// traits d'union ou les espaces multiples — Vosk peut rendre "dix-sept"
/// sous la forme "dix sept" selon le découpage du modèle.
String _normalizeSpoken(String value) {
  return value
      .toLowerCase()
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Écran d'exercice générique, piloté par [Exercise.responseMode]
/// (cf. PRD 6.2). Réutilise le mécanisme de reconnaissance vocale validé par
/// le spike technique (grammaire fermée sur un mot isolé par question).
///
/// Sélection adaptative (PRD 6.5, [AdaptiveQuestionSelector]) et calcul des
/// récompenses (PRD 6.7, [AverageTimeRewardCalculator]) branchés derrière
/// leurs interfaces respectives.
class ExerciseRunnerScreen extends StatefulWidget {
  const ExerciseRunnerScreen({
    super.key,
    required this.profileId,
    required this.exerciseId,
  });

  final String profileId;
  final String exerciseId;

  @override
  State<ExerciseRunnerScreen> createState() => _ExerciseRunnerScreenState();
}

class _ExerciseRunnerScreenState extends State<ExerciseRunnerScreen> {
  final _voskService = VoskRecognitionService();
  final _feedbackSound = FeedbackSoundService();
  late final QuestionSelector _questionSelector;
  final _rewardCalculator = const AverageTimeRewardCalculator();
  late final QuestionStatsRepository _questionStats;

  // Retour immédiat bonne/mauvaise réponse (son + flash), sur chaque
  // tentative — y compris une réponse fausse rapide par ailleurs ignorée
  // par le calcul de sélection adaptative (cf. PRD 6.5).
  Color? _flashColor;
  int _flashToken = 0;

  Exercise? _exercise;
  _RunnerStatus _status = _RunnerStatus.loading;
  String? _error;

  // Questions "normales" (non séquentielles).
  int _questionsAnswered = 0;
  Question? _currentQuestion;
  int _wrongAttemptsOnCurrent = 0;
  DateTime? _questionStartedAt;
  final List<Duration> _responseTimes = [];
  String? _revealedAnswer;

  // Texte reconnu par la reconnaissance vocale, affiché à côté du micro
  // pour le débogage (partiel en cours d'écoute, ou dernier résultat final
  // reçu) — utile pour diagnostiquer les mots mal reconnus (cf. PRD 12).
  String _recognizedDebugText = '';
  _MicState _micState = _MicState.idle;

  // Abonnements aux flux Vosk : conservés pour être annulés à la fermeture
  // de l'écran. Sans ça, ils survivaient à l'écran et continuaient de
  // recevoir des événements du plugin (qui est un singleton), ce qui
  // faisait planter l'app à l'ouverture de l'exercice suivant.
  StreamSubscription<String>? _partialSub;
  StreamSubscription<String>? _finalSub;

  /// Sérialise les transitions de question : une réponse tardive de Vosk
  /// (le flux continue de livrer ce qu'il avait en tampon après `stop()`)
  /// pouvait sinon relancer `_pickNextQuestion` en parallèle d'une
  /// transition déjà en cours, avec deux écoutes concurrentes côté natif.
  bool _handlingAnswer = false;

  /// Mode de saisie courant sur les exercices vocal + tactile (cf. PRD 6.2).
  _InputMode _inputMode = _InputMode.vocal;

  /// Mots de la grammaire courante validables dès le résultat partiel
  /// (cf. [_rememberGrammar]).
  Set<String> _earlyAcceptable = const {};

  /// Délai de stabilisation d'un résultat partiel avant de le valider sans
  /// attendre la fin de parole (cf. [_onPartial]).
  static const _partialCommitDelay = Duration(milliseconds: 400);
  Timer? _partialCommitTimer;
  String _lastPartial = '';
  final _presentationRandom = Random();
  LetterPresentation? _presentation;
  List<int>? _tactileOptions;

  // Dénombrement : famille d'animaux et images tirées au hasard à chaque
  // question (cf. PRD 5.1) — jamais la même famille deux questions de
  // suite.
  final _denombrementRandom = Random();
  String? _lastAnimalFamily;

  // Images de la question courante, et disposition calculée à partir d'elles.
  // La disposition dépend du format de la zone que l'écran laisse réellement
  // aux objets : elle ne peut donc pas être figée en même temps que le tirage
  // des images, elle est mémoïsée à la première mise en page (cf.
  // [_scatteredObjectsFor]). Le tirage étant rejoué avec une graine fixée par
  // question, une reconstruction à format identique redonne exactement la
  // même disposition — sans quoi les objets sauteraient d'un endroit à
  // l'autre sous les yeux de l'enfant.
  List<String>? _denombrementAssets;
  int? _denombrementSeed;
  List<ScatteredObject>? _scatterCache;
  double? _scatterCacheAspect;

  // Animation grenouille (exercices de calcul, cf. PRD 6.7bis) : avance
  // d'une image sur une bonne réponse rapide (≤ 5s), recule sur une erreur
  // ou une réponse trop lente. Débute à 0 (bas du toboggan) à chaque série
  // et reste dans [0, _frogFrameCount - 1].
  static const _frogFrameCount = 12;
  static const _frogAdvanceDelay = Duration(seconds: 5);
  int _frogFrameIndex = 0;
  DateTime? _attemptStartedAt;

  // Comptage (exercice séquentiel, cf. PRD 5.1/6.2).
  static const _maxSequentialAttempts = 5;
  int _sequentialAttemptNumber = 1;
  int _sequentialIndex = 0; // 0-based ; le chiffre visé est index+1.
  int _sequentialBestReached = 0;

  int? _finalBadgeLevel;
  int? _finalSequentialScore;
  String? _endMessage;

  @override
  void initState() {
    super.initState();
    _questionStats = context.read<QuestionStatsRepository>();
    _questionSelector = AdaptiveQuestionSelector(_questionStats);
    _load();
  }

  Future<void> _load() async {
    final exercise = context.read<CatalogStore>().byId(widget.exerciseId);
    if (exercise == null) {
      setState(() {
        _status = _RunnerStatus.error;
        _error = 'Exercice introuvable.';
      });
      return;
    }
    _exercise = exercise;

    if (exercise.responseMode.acceptsVocal) {
      try {
        await _voskService.initialize();
        _partialSub = _voskService.partialResults().listen(_onPartial);
        _finalSub = _voskService.finalResults().listen(_onVocalResult);
        // Grammaire posée UNE SEULE FOIS, avant toute écoute, et couvrant
        // tout l'exercice. La reconfigurer entre deux questions faisait
        // planter l'app : le thread de reconnaissance natif pouvait encore
        // être en train de consommer de l'audio (`stop()` ne l'interrompt
        // pas immédiatement) et Kaldi partait alors en assertion fatale
        // dans AcceptWaveform (cf. PRD 8.1).
        await _voskService.setGrammar(_exerciseGrammar(exercise));
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _status = _RunnerStatus.error;
          _error = e.toString();
        });
        return;
      }
    }

    if (!mounted) return;
    if (exercise.isSequentialException) {
      await _startSequentialQuestion();
    } else {
      await _pickNextQuestion();
    }
  }

  // ---------------------------------------------------------------------
  // Questions normales
  // ---------------------------------------------------------------------

  Future<void> _pickNextQuestion() async {
    final exercise = _exercise!;
    final next = await _questionSelector.selectNext(
      profileId: widget.profileId,
      exerciseId: widget.exerciseId,
      allQuestions: exercise.questions,
      previous: _currentQuestion,
    );
    if (!mounted) return;
    setState(() {
      _currentQuestion = next;
      _wrongAttemptsOnCurrent = 0;
      _revealedAnswer = null;
      _recognizedDebugText = '';
      _micState = _MicState.idle;
      _status = _RunnerStatus.playing;
      _questionStartedAt = DateTime.now();
      _attemptStartedAt = DateTime.now();
      // Présentation visuelle aléatoire pour les variantes Alphabet
      // concernées (cf. PRD 5.1/8.1) — tirée à chaque nouvelle question.
      _presentation = exercise.randomPresentation
          ? randomLetterPresentation(next.displayValue, _presentationRandom)
          : null;
      // Images tirées une seule fois par question (cf. PRD 5.1) ; leur
      // disposition, elle, attend de connaître la place disponible.
      _denombrementAssets = next.objectCount != null
          ? _pickDenombrementImages(next.objectCount!)
          : null;
      _denombrementSeed = _denombrementRandom.nextInt(1 << 32);
      _scatterCache = null;
      _scatterCacheAspect = null;
      // Propositions QCM tirées une seule fois par question (cf. PRD 6.2) —
      // sinon elles se régénèrent à chaque reconstruction de l'écran (ex. à
      // chaque résultat partiel de l'écoute continue) et changent sans
      // arrêt sous les yeux de l'enfant.
      _tactileOptions =
          exercise.responseMode.acceptsTactile && next.expectedAnswer != null
          ? _TactileOptions.buildOptions(
              int.parse(next.expectedAnswer!),
              exercise.maxAnswerValue,
              Random(),
            )
          : null;
    });
    if (_shouldListen(exercise) && next.expectedSpokenWord != null) {
      // Écoute automatique dès l'apparition de la question (cf. PRD 6.2) :
      // pas besoin d'appuyer sur un bouton, l'enfant peut répondre tout de
      // suite à voix haute. La grammaire, elle, est déjà posée pour tout
      // l'exercice (cf. _exerciseGrammar).
      await _startListening();
    }
  }

  /// Vrai si l'écoute vocale doit être active pour cet exercice : toujours
  /// pour un exercice purement vocal, seulement en mode vocal choisi pour
  /// un exercice vocal + tactile (cf. PRD 6.2).
  bool _shouldListen(Exercise exercise) {
    if (!exercise.responseMode.acceptsVocal) return false;
    if (!exercise.responseMode.acceptsTactile) return true;
    return _inputMode == _InputMode.vocal;
  }

  /// Grammaire de l'exercice entier : toutes les réponses attendues de ses
  /// questions, plus tous les nombres de la plage pour les exercices de
  /// calcul (cf. PRD 6.2). Couvrir tout l'exercice — et pas seulement la
  /// réponse de la question courante — permet à Vosk de transcrire *ce que
  /// l'enfant a réellement dit* quand il se trompe, au lieu de renvoyer
  /// "[unk]" ; c'est aussi ce qui rend la grammaire constante d'une
  /// question à l'autre, donc jamais reconfigurée en cours d'écoute.
  List<String> _exerciseGrammar(Exercise exercise) {
    final words = <String>{
      for (final question in exercise.questions)
        ...question.acceptedSpokenWords,
    };
    final max = exercise.maxAnswerValue;
    if (max != null) words.addAll(_numericGrammarWords(max));
    final list = words.toList();
    _rememberGrammar(list);
    return list;
  }

  /// Tous les mots-chiffres de 0 à [max] (cf. PRD 6.2, vocal + tactile) —
  /// permet à Vosk de transcrire n'importe quel nombre dit par l'enfant
  /// dans cette plage, pas seulement la bonne réponse.
  List<String> _numericGrammarWords(int max) {
    return [
      for (var i = 0; i <= max; i++)
        if (digitWords[i.toString()] != null) digitWords[i.toString()]!,
    ];
  }

  /// Retient les mots attendus et calcule ceux qu'on peut valider dès le
  /// résultat *partiel* : ceux dont aucun autre mot de la grammaire n'est
  /// le prolongement. "dix" en est exclu tant que "dix-sept" est attendu,
  /// sinon on répondrait 10 pendant que l'enfant dit encore 17.
  void _rememberGrammar(List<String> words) {
    final normalized = words.map(_normalizeSpoken).toList();
    _earlyAcceptable = {
      for (final word in normalized)
        if (!normalized.any((other) => other.startsWith('$word '))) word,
    };
  }

  void _onPartial(String text) {
    if (_status != _RunnerStatus.listening) return;
    final heard = _normalizeSpoken(text);
    // Partiel vide = silence : on laisse l'indicateur tel quel plutôt que de
    // le faire clignoter entre deux syllabes.
    if (heard.isEmpty) return;
    _showHeard(text, heard);
    if (heard == _lastPartial) return;
    _lastPartial = heard;
    _partialCommitTimer?.cancel();
    // Validation anticipée (cf. PRD 6.2) : sans elle, il faut attendre que
    // Vosk détecte la fin de parole (un silence assez long), ce qui donne
    // cette impression de capture lente. On ne valide toutefois qu'un mot
    // attendu sans ambiguïté ET stabilisé pendant [_partialCommitDelay] :
    // Vosk révise ses partiels en cours de route ("trois" -> "treize"), et
    // valider le premier venu enregistrerait une réponse fausse.
    if (!_earlyAcceptable.contains(heard)) return;
    _partialCommitTimer = Timer(_partialCommitDelay, () {
      if (!mounted || _status != _RunnerStatus.listening) return;
      if (_lastPartial != heard) return;
      _onSpokenAnswer(heard);
    });
  }

  void _onVocalResult(String text) {
    _partialCommitTimer?.cancel();
    final heard = _normalizeSpoken(text);
    if (heard.isEmpty) return;
    _showHeard(text, heard);
    _onSpokenAnswer(heard);
  }

  void _showHeard(String raw, String normalized) {
    if (!mounted) return;
    setState(() {
      _recognizedDebugText = raw;
      _micState = normalized == _voskUnknown
          ? _MicState.unrecognized
          : _MicState.recognized;
    });
  }

  /// Vrai si [heard] (déjà normalisé) est l'une des prononciations qui
  /// valident [question] — le mot cible ou l'une de ses variantes (cf.
  /// [Question.acceptedSpokenWords]).
  bool _matchesSpoken(Question question, String heard) {
    return question.acceptedSpokenWords.any(
      (word) => _normalizeSpoken(word) == heard,
    );
  }

  void _onSpokenAnswer(String heard) {
    if (!mounted) return;
    // Du son capté mais aucun mot de la grammaire reconnu : ce n'est pas une
    // réponse fausse, seulement une captation ratée. Le micro passe au rouge
    // (cf. PRD 6.2) sans compter de tentative ni faire reculer la grenouille.
    if (heard == _voskUnknown) return;
    if (_exercise!.isSequentialException) {
      _handleSequentialAnswer(heard);
    } else {
      _handleNormalAnswer(spoken: heard);
    }
  }

  Future<void> _startListening() async {
    if (!mounted) return;
    _partialCommitTimer?.cancel();
    _lastPartial = '';
    setState(() {
      _status = _RunnerStatus.listening;
      _micState = _MicState.idle;
    });
    await _voskService.start();
  }

  /// Bascule vocal <-> tactile sur les exercices qui acceptent les deux
  /// (cf. PRD 6.2) : une seule entrée active à la fois, l'écoute est
  /// réellement arrêtée en mode tactile plutôt que laissée tourner.
  Future<void> _setInputMode(_InputMode mode) async {
    if (_inputMode == mode || _exercise == null) return;
    setState(() {
      _inputMode = mode;
      _recognizedDebugText = '';
      _micState = _MicState.idle;
    });
    if (mode == _InputMode.tactile) {
      await _voskService.stop();
      if (!mounted) return;
      if (_status == _RunnerStatus.listening) {
        setState(() => _status = _RunnerStatus.playing);
      }
      return;
    }
    if (_currentQuestion?.expectedSpokenWord == null) return;
    await _startListening();
  }

  void _handleTactileAnswer(String answer) {
    _handleNormalAnswer(tactile: answer);
  }

  Future<void> _handleNormalAnswer({String? spoken, String? tactile}) async {
    // Une réponse n'est recevable que pendant la question elle-même. Vosk
    // continue de livrer ce qu'il avait en tampon après `stop()` : sans ce
    // garde, un résultat tardif était traité pendant la révélation ou la
    // fin de série et enclenchait une seconde transition de question en
    // parallèle de la première (cf. plantages, PRD 8.1).
    if (_handlingAnswer) return;
    if (_status != _RunnerStatus.playing &&
        _status != _RunnerStatus.listening) {
      return;
    }
    final question = _currentQuestion;
    if (question == null) return;
    _handlingAnswer = true;
    try {
      await _processNormalAnswer(question, spoken: spoken, tactile: tactile);
    } finally {
      _handlingAnswer = false;
    }
  }

  Future<void> _processNormalAnswer(
    Question question, {
    String? spoken,
    String? tactile,
  }) async {
    final correct =
        (spoken != null && _matchesSpoken(question, spoken)) ||
        (tactile != null && tactile == question.expectedAnswer);

    if (_exercise!.frogAnimation) {
      final attemptElapsed = _attemptStartedAt == null
          ? Duration.zero
          : DateTime.now().difference(_attemptStartedAt!);
      final advance = correct && attemptElapsed <= _frogAdvanceDelay;
      setState(() {
        _frogFrameIndex = (_frogFrameIndex + (advance ? 1 : -1)).clamp(
          0,
          _frogFrameCount - 1,
        );
      });
      _attemptStartedAt = DateTime.now();
    }

    _flashAndPlay(correct: correct);

    if (!correct) {
      setState(() => _wrongAttemptsOnCurrent++);
      // Révélation de la réponse après 2 échecs (cf. PRD 6.2), avec une
      // pénalité fixe de 5s ajoutée au temps enregistré pour cette question
      // (cf. PRD 6.5) — une réponse fausse rapide, elle, est simplement
      // ignorée et ne modifie rien tant que ce seuil n'est pas atteint.
      if (_wrongAttemptsOnCurrent >= 2) {
        await _voskService.stop();
        final elapsed =
            _elapsedSinceQuestionStart() + const Duration(seconds: 5);
        _responseTimes.add(elapsed);
        await _questionStats.recordAttempt(
          widget.profileId,
          widget.exerciseId,
          question.id,
          elapsed,
          correct: false,
        );
        if (!mounted) return;
        setState(() {
          _status = _RunnerStatus.revealed;
          _revealedAnswer =
              question.expectedAnswer ?? question.expectedSpokenWord;
        });
        Future.delayed(const Duration(seconds: 2), _afterQuestionAnswered);
      }
      return;
    }

    await _voskService.stop();
    final elapsed = _elapsedSinceQuestionStart();
    _responseTimes.add(elapsed);
    await _questionStats.recordAttempt(
      widget.profileId,
      widget.exerciseId,
      question.id,
      elapsed,
      correct: true,
    );
    await _afterQuestionAnswered();
  }

  void _flashAndPlay({required bool correct}) {
    if (!mounted) return;
    setState(() {
      _flashColor = correct ? Colors.green : Colors.red;
      _flashToken++;
    });
    if (correct) {
      _feedbackSound.playCorrect();
    } else {
      _feedbackSound.playIncorrect();
    }
  }

  Duration _elapsedSinceQuestionStart() {
    return _questionStartedAt == null
        ? Duration.zero
        : DateTime.now().difference(_questionStartedAt!);
  }

  Future<void> _afterQuestionAnswered() async {
    if (!mounted) return;
    _questionsAnswered++;
    if (_questionsAnswered >= _exercise!.questionsPerSeries) {
      await _finishSeries();
    } else {
      await _pickNextQuestion();
    }
  }

  Future<void> _finishSeries() async {
    final badgeLevel = _rewardCalculator.calculateBadgeLevel(
      exercise: _exercise!,
      responseTimes: _responseTimes,
    );
    await context.read<PerformanceStore>().recordAttempt(
      widget.profileId,
      widget.exerciseId,
      badgeLevel: badgeLevel,
    );
    if (!mounted) return;
    setState(() {
      _finalBadgeLevel = badgeLevel;
      _endMessage = pickEndMessage(badgeLevel);
      _status = _RunnerStatus.finished;
    });
  }

  // ---------------------------------------------------------------------
  // Comptage (exercice séquentiel)
  // ---------------------------------------------------------------------

  Future<void> _startSequentialQuestion() async {
    if (!mounted) return;
    final questions = _exercise!.questions;
    final question = questions[_sequentialIndex];
    setState(() {
      _currentQuestion = question;
      _revealedAnswer = null;
      _recognizedDebugText = '';
      _micState = _MicState.idle;
      _status = _RunnerStatus.playing;
    });
    await _startListening();
  }

  Future<void> _handleSequentialAnswer(String spoken) async {
    // Même garde que pour les questions normales (cf. _handleNormalAnswer) :
    // un résultat Vosk tardif ne doit pas relancer une seconde transition.
    if (_handlingAnswer) return;
    if (_status != _RunnerStatus.playing &&
        _status != _RunnerStatus.listening) {
      return;
    }
    final question = _currentQuestion;
    if (question == null) return;
    _handlingAnswer = true;
    try {
      await _processSequentialAnswer(question, spoken);
    } finally {
      _handlingAnswer = false;
    }
  }

  Future<void> _processSequentialAnswer(
    Question question,
    String spoken,
  ) async {
    final correct = _matchesSpoken(question, spoken);
    _flashAndPlay(correct: correct);

    if (correct) {
      final reached = _sequentialIndex + 1;
      if (reached > _sequentialBestReached) _sequentialBestReached = reached;
      if (reached == _exercise!.questions.length) {
        // Arrêt automatique dès que l'enfant atteint 10 (cf. PRD 6.7).
        await _finishSequential();
        return;
      }
      await _voskService.stop();
      if (!mounted) return;
      setState(() => _sequentialIndex++);
      await _startSequentialQuestion();
      return;
    }

    // Erreur : révélation orale (texte ici, pas encore d'audio) et reprise
    // depuis le début (cf. PRD 5.1).
    await _voskService.stop();
    if (!mounted) return;
    setState(() {
      _status = _RunnerStatus.revealed;
      _revealedAnswer = question.expectedSpokenWord;
    });
    _sequentialAttemptNumber++;
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      if (_sequentialAttemptNumber > _maxSequentialAttempts) {
        await _finishSequential();
      } else {
        setState(() => _sequentialIndex = 0);
        await _startSequentialQuestion();
      }
    });
  }

  Future<void> _finishSequential() async {
    final score = _sequentialBestReached >= 10
        ? 3
        : _sequentialBestReached >= 8
        ? 2
        : _sequentialBestReached >= 5
        ? 1
        : 0;
    await context.read<PerformanceStore>().recordAttempt(
      widget.profileId,
      widget.exerciseId,
      badgeLevel: score,
    );
    if (!mounted) return;
    setState(() {
      _finalSequentialScore = score;
      _endMessage = pickEndMessage(score);
      _status = _RunnerStatus.finished;
    });
  }

  @override
  void dispose() {
    // Les abonnements doivent être coupés AVANT de libérer le service : le
    // plugin Vosk est un singleton, et des abonnements laissés vivants
    // continuaient de recevoir les événements de l'écran suivant (modèle et
    // recognizer déjà détruits côté natif) — d'où des plantages en
    // enchaînant les exercices.
    _partialCommitTimer?.cancel();
    _partialSub?.cancel();
    _finalSub?.cancel();
    _partialSub = null;
    _finalSub = null;
    // Arrêt puis libération séquencés : `dispose()` du plugin ne doit pas
    // partir en parallèle d'une capture encore active.
    unawaited(_voskService.stop().then((_) => _voskService.dispose()));
    _feedbackSound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_exercise?.title ?? 'Exercice')),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _buildBody(),
            ),
            Positioned.fill(
              child: AnswerFlashOverlay(
                key: ValueKey(_flashToken),
                color: _flashColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _RunnerStatus.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Préparation de l\'exercice...'),
            ],
          ),
        );
      case _RunnerStatus.error:
        return Center(
          child: Text(
            'Erreur : $_error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      case _RunnerStatus.finished:
        return _buildFinished();
      case _RunnerStatus.playing:
      case _RunnerStatus.listening:
      case _RunnerStatus.revealed:
        return _buildQuestion();
    }
  }

  /// Affiche la valeur de la question, avec police/rotation aléatoires
  /// pour les variantes Alphabet concernées (cf. PRD 5.1/8.1).
  Widget _buildLetterDisplay(String displayValue) {
    final presentation = _presentation;
    final text = Text(
      displayValue,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        fontFamily: presentation?.fontFamily,
      ),
    );
    if (presentation == null) return text;
    return Transform.rotate(angle: presentation.rotation, child: text);
  }

  /// Tire une famille d'animaux (différente de la précédente question, cf.
  /// PRD 5.1) puis [count] images distinctes au hasard dans cette famille.
  List<String> _pickDenombrementImages(int count) {
    var family =
        animalFamilyFolders[_denombrementRandom.nextInt(
          animalFamilyFolders.length,
        )];
    if (animalFamilyFolders.length > 1) {
      while (family == _lastAnimalFamily) {
        family =
            animalFamilyFolders[_denombrementRandom.nextInt(
              animalFamilyFolders.length,
            )];
      }
    }
    _lastAnimalFamily = family;
    final indices = List.generate(imagesPerAnimalFamily, (i) => i + 1)
      ..shuffle(_denombrementRandom);
    return indices.take(count).map((i) => animalImagePath(family, i)).toList();
  }

  /// Disposition des objets pour un cadre de rapport [aspect], mémoïsée : le
  /// tirage est rejoué à l'identique tant que le format ne change pas, si
  /// bien qu'une reconstruction ne déplace jamais les objets.
  List<ScatteredObject> _scatteredObjectsFor(double aspect) {
    if (_scatterCache != null && _scatterCacheAspect == aspect) {
      return _scatterCache!;
    }
    _scatterCacheAspect = aspect;
    _scatterCache = scatterObjects(
      _denombrementAssets!,
      Random(_denombrementSeed!),
      boxAspect: aspect,
    );
    return _scatterCache!;
  }

  /// Dénombrement : les objets à compter, dispersés sans chevauchement avec
  /// des tailles et des orientations variées (cf. PRD 5.1). Occupe toute la
  /// place que l'écran lui laisse — plus la zone est haute, plus les objets
  /// sont gros.
  Widget _buildObjectImages() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Sans contrainte de hauteur (cas d'une mise en page défilante), on
        // retombe sur le format par défaut.
        final aspect = constraints.hasBoundedHeight
            ? constraints.maxHeight / width
            : defaultScatterBoxAspect;
        return SizedBox(
          width: width,
          height: width * aspect,
          child: Stack(
            children: [
              for (final object in _scatteredObjectsFor(aspect))
                Positioned(
                  left: (object.center.dx - object.size / 2) * width,
                  top: (object.center.dy - object.size / 2) * width,
                  width: object.size * width,
                  height: object.size * width,
                  child: Transform.rotate(
                    angle: object.rotation,
                    child: Image.asset(object.asset, fit: BoxFit.contain),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Progression dans la série (ex. "5 / 20") — pour Comptage, position
  /// dans la tentative en cours plutôt qu'une série au sens habituel (cf.
  /// PRD 6.2 : Comptage n'a pas de série de questions).
  Widget _buildProgressIndicator() {
    final exercise = _exercise!;
    final int current;
    final int total;
    if (exercise.isSequentialException) {
      current = _sequentialIndex + 1;
      total = exercise.questions.length;
    } else {
      current = _questionsAnswered + 1;
      total = exercise.questionsPerSeries;
    }
    final progress = (current / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: progress, minHeight: 8),
        ),
        const SizedBox(height: 4),
        Text(
          '$current / $total',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }

  /// Grenouille qui progresse le long du toboggan au fil de la série (cf.
  /// PRD 6.7bis) — une image sur 12, avance/recule selon la réponse.
  Widget _buildFrogAnimation() {
    final n = (_frogFrameIndex + 1).toString().padLeft(2, '0');
    return Center(
      child: Image.asset(
        'assets/images/grenouille/grenouille_$n.png',
        height: 100,
      ),
    );
  }

  /// Couleur du micro selon ce qu'entend la reconnaissance (cf. PRD 6.2) :
  /// gris = rien d'audible, rouge = du son mais rien de reconnu, vert = un
  /// mot de la grammaire reconnu.
  Color _micColor() {
    switch (_micState) {
      case _MicState.idle:
        return Colors.grey;
      case _MicState.unrecognized:
        return Colors.red.shade600;
      case _MicState.recognized:
        return Colors.green.shade600;
    }
  }

  /// Bascule vocal / tactile (cf. PRD 6.2), affichée seulement sur les
  /// exercices qui acceptent réellement les deux entrées.
  Widget _buildInputModeSwitch() {
    return Center(
      child: SegmentedButton<_InputMode>(
        segments: const [
          ButtonSegment(
            value: _InputMode.vocal,
            icon: Icon(Icons.mic),
            label: Text('Je dis'),
          ),
          ButtonSegment(
            value: _InputMode.tactile,
            icon: Icon(Icons.touch_app),
            label: Text('Je touche'),
          ),
        ],
        selected: {_inputMode},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => _setInputMode(selection.first),
      ),
    );
  }

  Widget _buildQuestion() {
    final exercise = _exercise!;
    final question = _currentQuestion!;
    final revealed = _status == _RunnerStatus.revealed;
    final bothInputs =
        exercise.responseMode.acceptsVocal &&
        exercise.responseMode.acceptsTactile;
    // Une seule entrée à la fois quand l'exercice accepte les deux : c'est
    // la bascule qui décide, plutôt que d'afficher micro et boutons
    // ensemble (cf. PRD 6.2).
    final showMic =
        exercise.responseMode.acceptsVocal &&
        (!bothInputs || _inputMode == _InputMode.vocal);
    final showButtons =
        exercise.responseMode.acceptsTactile &&
        _tactileOptions != null &&
        (!bothInputs || _inputMode == _InputMode.tactile);

    final answerArea = <Widget>[
      if (revealed)
        Text(
          'La bonne réponse était : "$_revealedAnswer"',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.orange),
        )
      else ...[
        if (bothInputs) ...[
          _buildInputModeSwitch(),
          const SizedBox(height: 12),
        ],
        // Écoute automatique (cf. PRD 6.2) : indicateur passif (icône
        // micro, couleur selon ce qui est entendu) sans bouton. Texte
        // reconnu affiché à côté pour le débogage (cf. PRD 12).
        if (showMic)
          // Le micro reste rigoureusement au centre : les deux moitiés se
          // font équilibre, si bien que l'apparition du texte reconnu à
          // droite ne le déplace plus (il sautait auparavant à chaque mot
          // entendu, la ligne entière étant centrée).
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Icon(Icons.mic, size: 40, color: _micColor()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    _recognizedDebugText.isEmpty
                        ? ''
                        : '"$_recognizedDebugText"',
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        if (showButtons) ...[
          const SizedBox(height: 8),
          _TactileOptions(
            options: _tactileOptions!,
            onAnswer: _handleTactileAnswer,
          ),
        ],
      ],
    ];

    // Dénombrement : les objets méritent toute la place disponible, donc
    // progression en haut, réponses ancrées en bas, et la zone de comptage
    // prend tout ce qui reste (cf. PRD 5.1). Les autres exercices gardent la
    // mise en page défilante, plus tolérante à un contenu haut (grenouille +
    // 8 propositions sur un petit écran).
    if (_denombrementAssets != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 8),
          Expanded(child: _buildObjectImages()),
          const SizedBox(height: 12),
          ...answerArea,
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressIndicator(),
          if (exercise.frogAnimation) ...[
            const SizedBox(height: 8),
            _buildFrogAnimation(),
          ],
          const SizedBox(height: 8),
          _buildLetterDisplay(question.displayValue),
          const SizedBox(height: 12),
          ...answerArea,
        ],
      ),
    );
  }

  Widget _buildFinished() {
    final exercise = _exercise!;
    final isSequential = exercise.isSequentialException;
    final level = isSequential ? _finalSequentialScore! : _finalBadgeLevel!;
    // Message de fin d'exercice tiré de la banque de variantes (cf. PRD
    // 6.7) — texte pour l'instant, pas encore la banque audio complète.
    final message = _endMessage!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Le niveau 0 garde un cœur plutôt que l'emplacement vide de
          // [BadgeIcon] : sur l'écran de fin, il faut consoler l'enfant, pas
          // lui montrer la place que sa coupe n'occupe pas.
          if (level > 0)
            BadgeIcon(level: level, size: 140)
          else
            Icon(Icons.favorite, size: 72, color: Colors.pink.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }
}

class _TactileOptions extends StatelessWidget {
  const _TactileOptions({required this.options, required this.onAnswer});

  /// Liste déjà tirée (cf. [buildOptions]) — calculée une seule fois par
  /// question par l'écran parent, pas ici. La calculer dans ce `build()`
  /// aurait régénéré (et mélangé) les propositions à chaque reconstruction
  /// de l'écran, ex. à chaque résultat partiel de l'écoute vocale continue
  /// (cf. PRD 6.2), les faisant changer sans arrêt sous les yeux de l'enfant.
  final List<int> options;
  final ValueChanged<String> onAnswer;

  static const _perRow = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < options.length; i += _perRow) ...[
          if (i > 0) const SizedBox(height: 8),
          Row(
            children: [
              for (final option in options.skip(i).take(_perRow))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => onAnswer(option.toString()),
                      child: FittedBox(
                        child: Text(
                          '$option',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// 8 propositions au total (2 lignes de 4), groupées autour de [correct],
  /// sans jamais dépasser [maxValue] ni descendre sous 0 (cf. PRD 6.2). Peut
  /// renvoyer moins de 8 si l'exercice n'offre pas assez de valeurs valides
  /// à proximité (ex. correct = maxValue).
  static List<int> buildOptions(int correct, int? maxValue, Random random) {
    final nearby = <int>[];
    for (var distance = 1; nearby.length < 12 && distance <= 12; distance++) {
      for (final candidate in [correct - distance, correct + distance]) {
        if (candidate < 0) continue;
        if (maxValue != null && candidate > maxValue) continue;
        nearby.add(candidate);
      }
    }

    const targetTotal = 8; // 2 lignes de 4 (cf. PRD 6.2)
    final distractorCount = (targetTotal - 1).clamp(0, nearby.length);
    final distractors = nearby.take(distractorCount).toList();

    return [correct, ...distractors]..shuffle(random);
  }
}
