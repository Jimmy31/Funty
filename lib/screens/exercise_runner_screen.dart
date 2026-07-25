import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../models/question.dart';
import '../repositories/question_stats_repository.dart';
import '../services/adaptive_question_selector.dart';
import '../services/end_message_bank.dart';
import '../services/feedback_sound_service.dart';
import '../services/letter_presentation.dart';
import '../services/question_selector.dart';
import '../services/reward_calculator.dart';
import '../services/vosk_recognition_service.dart';
import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../widgets/answer_flash_overlay.dart';

enum _RunnerStatus { loading, playing, listening, revealed, finished, error }

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
  String _partialText = '';
  String? _revealedAnswer;
  final _presentationRandom = Random();
  LetterPresentation? _presentation;

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
        _voskService.partialResults().listen(_onPartial);
        _voskService.finalResults().listen(_onVocalResult);
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
      _partialText = '';
      _revealedAnswer = null;
      _status = _RunnerStatus.playing;
      _questionStartedAt = DateTime.now();
      // Présentation visuelle aléatoire pour les variantes Alphabet
      // concernées (cf. PRD 5.1/8.1) — tirée à chaque nouvelle question.
      _presentation = exercise.randomPresentation
          ? randomLetterPresentation(next.displayValue, _presentationRandom)
          : null;
    });
    if (exercise.responseMode.acceptsVocal && next.expectedSpokenWord != null) {
      await _voskService.setGrammar([next.expectedSpokenWord!]);
    }
  }

  void _onPartial(String text) {
    if (!mounted || _status != _RunnerStatus.listening) return;
    setState(() => _partialText = text);
  }

  void _onVocalResult(String text) {
    if (!mounted || text.isEmpty) return;
    if (_exercise!.isSequentialException) {
      _handleSequentialAnswer(text);
    } else {
      _handleNormalAnswer(spoken: text);
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _status = _RunnerStatus.listening;
      _partialText = '';
    });
    await _voskService.start();
  }

  Future<void> _stopListening() async {
    await _voskService.stop();
    if (!mounted) return;
    setState(() => _status = _RunnerStatus.playing);
  }

  void _handleTactileAnswer(String answer) {
    _handleNormalAnswer(tactile: answer);
  }

  Future<void> _handleNormalAnswer({String? spoken, String? tactile}) async {
    final question = _currentQuestion!;
    final correct =
        (spoken != null &&
            spoken.trim().toLowerCase() == question.expectedSpokenWord) ||
        (tactile != null && tactile == question.expectedAnswer);
    _flashAndPlay(correct: correct);

    if (!correct) {
      setState(() => _wrongAttemptsOnCurrent++);
      // Révélation de la réponse après 2 échecs (cf. PRD 6.2), avec une
      // pénalité fixe de 5s ajoutée au temps enregistré pour cette question
      // (cf. PRD 6.5) — une réponse fausse rapide, elle, est simplement
      // ignorée et ne modifie rien tant que ce seuil n'est pas atteint.
      if (_wrongAttemptsOnCurrent >= 2) {
        await _voskService.stop();
        final elapsed = _elapsedSinceQuestionStart() + const Duration(seconds: 5);
        _responseTimes.add(elapsed);
        await _questionStats.recordAttempt(
          widget.profileId,
          widget.exerciseId,
          question.id,
          elapsed,
        );
        setState(() {
          _status = _RunnerStatus.revealed;
          _revealedAnswer = question.expectedAnswer ?? question.expectedSpokenWord;
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
    );
    _afterQuestionAnswered();
  }

  void _flashAndPlay({required bool correct}) {
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
    final questions = _exercise!.questions;
    final question = questions[_sequentialIndex];
    setState(() {
      _currentQuestion = question;
      _partialText = '';
      _revealedAnswer = null;
      _status = _RunnerStatus.playing;
    });
    await _voskService.setGrammar([question.expectedSpokenWord!]);
  }

  Future<void> _handleSequentialAnswer(String spoken) async {
    final question = _currentQuestion!;
    final correct = spoken.trim().toLowerCase() == question.expectedSpokenWord;
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
      setState(() => _sequentialIndex++);
      await _startSequentialQuestion();
      return;
    }

    // Erreur : révélation orale (texte ici, pas encore d'audio) et reprise
    // depuis le début (cf. PRD 5.1).
    await _voskService.stop();
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
    _voskService.dispose();
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
            Padding(padding: const EdgeInsets.all(24), child: _buildBody()),
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
        fontSize: 90,
        fontWeight: FontWeight.bold,
        fontFamily: presentation?.fontFamily,
      ),
    );
    if (presentation == null) return text;
    return Transform.rotate(angle: presentation.rotation, child: text);
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

  Widget _buildQuestion() {
    final exercise = _exercise!;
    final question = _currentQuestion!;
    final listening = _status == _RunnerStatus.listening;
    final revealed = _status == _RunnerStatus.revealed;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 16),
          // Consigne orale systématique (cf. PRD 6.2) : texte pour
          // l'instant, pas encore le vrai enregistrement audio.
          Text(
            exercise.oralInstruction,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          _buildLetterDisplay(question.displayValue),
          const SizedBox(height: 24),
          if (revealed)
            Text(
              'La bonne réponse était : "$_revealedAnswer"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.orange),
            )
          else ...[
            if (exercise.responseMode.acceptsVocal)
              ElevatedButton.icon(
                onPressed: listening ? _stopListening : _startListening,
                icon: Icon(listening ? Icons.stop : Icons.mic),
                label: Text(listening ? 'Arrêter' : 'Écouter'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ),
              ),
            if (listening)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'En cours : "$_partialText"',
                  textAlign: TextAlign.center,
                ),
              ),
            if (exercise.responseMode.acceptsTactile &&
                question.expectedAnswer != null) ...[
              const SizedBox(height: 16),
              _TactileOptions(
                question: question,
                maxAnswerValue: exercise.maxAnswerValue,
                onAnswer: _handleTactileAnswer,
              ),
            ],
          ],
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
          Icon(
            level > 0 ? Icons.emoji_events : Icons.favorite,
            size: 72,
            color: level > 0 ? Colors.amber.shade600 : Colors.pink.shade300,
          ),
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
  const _TactileOptions({
    required this.question,
    required this.maxAnswerValue,
    required this.onAnswer,
  });

  final Question question;

  /// Aucune proposition ne doit dépasser cette valeur (ex. 5/10/20 pour les
  /// exercices Addition, cf. PRD 6.2) — `null` = pas de plafond.
  final int? maxAnswerValue;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    final correct = int.tryParse(question.expectedAnswer ?? '') ?? 0;
    final options = _buildOptions(correct, maxAnswerValue, Random());

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        for (final option in options)
          OutlinedButton(
            onPressed: () => onAnswer(option.toString()),
            child: Text('$option', style: const TextStyle(fontSize: 20)),
          ),
      ],
    );
  }

  /// 5 à 8 propositions au total, groupées autour de [correct], sans
  /// jamais dépasser [maxValue] ni descendre sous 0 (cf. PRD 6.2). Peut
  /// renvoyer moins de 5 si l'exercice n'offre pas assez de valeurs valides
  /// à proximité (ex. correct = maxValue).
  static List<int> _buildOptions(int correct, int? maxValue, Random random) {
    final nearby = <int>[];
    for (var distance = 1; nearby.length < 12 && distance <= 12; distance++) {
      for (final candidate in [correct - distance, correct + distance]) {
        if (candidate < 0) continue;
        if (maxValue != null && candidate > maxValue) continue;
        nearby.add(candidate);
      }
    }

    final targetTotal = 5 + random.nextInt(4); // 5 à 8 propositions
    final distractorCount = (targetTotal - 1).clamp(0, nearby.length);
    final distractors = nearby.take(distractorCount).toList();

    return [correct, ...distractors]..shuffle(random);
  }
}
