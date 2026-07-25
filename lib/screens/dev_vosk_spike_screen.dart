import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vosk_flutter_service/vosk_flutter_service.dart';

/// Ancien écran du spike technique de reconnaissance vocale (cf.
/// docs/PRD.md section 12), conservé comme outil de debug pour retester la
/// reconnaissance en isolation (sans passer par un exercice complet).
/// Accessible uniquement en mode debug (kDebugMode), depuis
/// [ProfileSelectionScreen].
const _modelAsset = 'assets/models/vosk-model-small-fr-0.22.zip';
const _sampleRate = 16000;

/// Un item testable : ce qui est affiché à l'enfant, et le mot attendu à
/// l'oral pour le reconnaître.
class _Item {
  const _Item(this.displayLabel, this.spokenWord);
  final String displayLabel;
  final String spokenWord;
}

enum _Mode { digits, letters }

const _digitItems = [
  _Item('0', 'zéro'),
  _Item('1', 'un'),
  _Item('2', 'deux'),
  _Item('3', 'trois'),
  _Item('4', 'quatre'),
  _Item('5', 'cinq'),
  _Item('6', 'six'),
  _Item('7', 'sept'),
  _Item('8', 'huit'),
  _Item('9', 'neuf'),
];

/// Prononciation usuelle des lettres de l'alphabet en français.
/// "ache"/"emme"/"enne"/"iks"/"zède" (H/M/N/X/Z) sont absentes du vocabulaire
/// du modèle small (confirmé par les logs Vosk : "Ignoring word missing in
/// vocabulary"). Le H étant muet en français, "ache" se prononce exactement
/// comme "hache" (l'outil) — un mot courant confirmé présent dans le
/// vocabulaire. Même logique pour "emme"≈"aime" et "enne"≈"haine". La
/// grammaire cible donc ces homophones réels à la place, sans rien changer
/// à ce que l'enfant doit dire. Pour X/Z, aucun homophone réel équivalent
/// n'existe ; "ixe" est confirmé présent en vocabulaire et acoustiquement
/// validé — cf. docs/PRD.md section 12.
const _letterItems = [
  _Item('A', 'a'),
  _Item('B', 'bé'),
  _Item('C', 'cé'),
  _Item('D', 'dé'),
  _Item('E', 'e'),
  _Item('F', 'effe'),
  _Item('G', 'gé'),
  _Item('H', 'hache'), // homophone de "ache", confirmé dans le vocabulaire
  _Item('I', 'i'),
  _Item('J', 'ji'),
  _Item('K', 'ka'),
  _Item('L', 'elle'),
  _Item('M', 'aime'), // homophone de "emme", confirmé dans le vocabulaire
  _Item('N', 'haine'), // homophone de "enne", confirmé dans le vocabulaire
  _Item('O', 'o'),
  _Item('P', 'pé'),
  _Item('Q', 'ku'),
  _Item('R', 'erre'),
  _Item('S', 'esse'),
  _Item('T', 'té'),
  _Item('U', 'u'),
  _Item('V', 'vé'),
  _Item('W', 'double vé'),
  _Item('X', 'ixe'), // en vocabulaire, correspondance acoustique validée
  _Item('Y', 'i grec'),
  _Item('Z', 'zède'), // toujours hors-vocabulaire, pas d'homophone trouvé
];

enum _Status { loadingModel, ready, listening, error }

class VoiceSpikeScreen extends StatefulWidget {
  const VoiceSpikeScreen({super.key});

  @override
  State<VoiceSpikeScreen> createState() => _VoiceSpikeScreenState();
}

class _VoiceSpikeScreenState extends State<VoiceSpikeScreen> {
  final _vosk = VoskFlutterPlugin.instance();
  final _modelLoader = ModelLoader();

  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  _Status _status = _Status.loadingModel;
  String? _error;

  _Mode _mode = _Mode.digits;
  List<_Item> get _items => _mode == _Mode.digits ? _digitItems : _letterItems;

  int _currentIndex = 0;
  _Item get _target => _items[_currentIndex];

  /// Résultat par mot testé pour la session en cours : texte reconnu (ou ''
  /// si aucun résultat), null si pas encore testé.
  final Map<String, String?> _resultsLog = {};

  String _partialText = '';
  String _lastRecognizedText = '';
  bool? _lastAnswerCorrect;
  Duration? _lastResponseTime;
  DateTime? _listenStartedAt;

  @override
  void initState() {
    super.initState();
    _loadModelAndRecognizer();
  }

  List<String> _grammarFor(_Mode mode) {
    final items = mode == _Mode.digits ? _digitItems : _letterItems;
    return [...items.map((i) => i.spokenWord), '[unk]'];
  }

  Future<void> _loadModelAndRecognizer() async {
    try {
      final modelPath = await _modelLoader.loadFromAssets(_modelAsset);
      final model = await _vosk.createModel(modelPath);
      final recognizer = await _vosk.createRecognizer(
        model: model,
        sampleRate: _sampleRate,
        grammar: _grammarFor(_mode),
      );
      final speechService = await _vosk.initSpeechService(recognizer);

      speechService.onPartial().listen(_onPartial);
      speechService.onResult().listen(_onResult);

      setState(() {
        _model = model;
        _recognizer = recognizer;
        _speechService = speechService;
        _status = _Status.ready;
        _resetSession();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _status = _Status.error;
      });
    }
  }

  Future<void> _switchMode(_Mode mode) async {
    if (mode == _mode || _recognizer == null) return;
    setState(() => _mode = mode);
    await _recognizer!.setGrammar(_grammarFor(mode));
    setState(_resetSession);
  }

  void _resetSession() {
    _currentIndex = 0;
    _resultsLog.clear();
    _clearCurrentResult();
  }

  void _clearCurrentResult() {
    _partialText = '';
    _lastRecognizedText = '';
    _lastAnswerCorrect = null;
    _lastResponseTime = null;
  }

  void _goToNext() {
    _currentIndex = (_currentIndex + 1) % _items.length;
    _clearCurrentResult();
  }

  void _onPartial(String partialJson) {
    final text = _extractText(partialJson, key: 'partial');
    if (!mounted) return;
    setState(() => _partialText = text);
  }

  void _onResult(String resultJson) {
    final text = _extractText(resultJson, key: 'text');
    if (text.isEmpty) return;

    final elapsed = _listenStartedAt == null
        ? null
        : DateTime.now().difference(_listenStartedAt!);

    if (!mounted) return;
    setState(() {
      _lastRecognizedText = text;
      _lastResponseTime = elapsed;
      _lastAnswerCorrect = text.trim().toLowerCase() == _target.spokenWord;
      _resultsLog[_target.displayLabel] = text;
      _status = _Status.ready;
    });
  }

  String _extractText(String json, {required String key}) {
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return (decoded[key] as String?)?.trim() ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _startListening() async {
    if (_speechService == null) return;
    setState(() {
      _status = _Status.listening;
      _partialText = '';
      _lastRecognizedText = '';
      _lastAnswerCorrect = null;
      _listenStartedAt = DateTime.now();
    });
    await _speechService!.start();
  }

  Future<void> _stopListening() async {
    if (_speechService == null) return;
    await _speechService!.stop();
    if (!mounted) return;
    setState(() => _status = _Status.ready);
  }

  @override
  void dispose() {
    _speechService?.dispose();
    _recognizer?.dispose();
    _model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spike — Reconnaissance vocale')),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24), child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _Status.loadingModel:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Chargement du modèle vocal (première fois : extraction du zip)...',
              ),
            ],
          ),
        );
      case _Status.error:
        return Center(
          child: Text(
            'Erreur : $_error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      case _Status.ready:
      case _Status.listening:
        return _buildExercise();
    }
  }

  Widget _buildExercise() {
    final listening = _status == _Status.listening;
    final testedCount = _resultsLog.length;
    // SingleChildScrollView : quand le résultat s'affiche, le contenu peut
    // dépasser la hauteur visible (ex. sous la barre de gestion Android) ;
    // on rend la vue défilable plutôt que de risquer un bouton inaccessible.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<_Mode>(
            segments: const [
              ButtonSegment(value: _Mode.digits, label: Text('Chiffres')),
              ButtonSegment(value: _Mode.letters, label: Text('Lettres')),
            ],
            selected: {_mode},
            onSelectionChanged: listening
                ? null
                : (selection) => _switchMode(selection.first),
          ),
          const SizedBox(height: 12),
          Text(
            'Progression : $testedCount / ${_items.length}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _mode == _Mode.digits
                ? 'Dis le chiffre affiché à voix haute :'
                : 'Dis le nom de la lettre affichée à voix haute :',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Text(
            _target.displayLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '(attendu : "${_target.spokenWord}")',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: listening ? _stopListening : _startListening,
            icon: Icon(listening ? Icons.stop : Icons.mic),
            label: Text(listening ? 'Arrêter' : 'Écouter'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
          ),
          const SizedBox(height: 12),
          if (listening)
            Text('En cours : "$_partialText"', textAlign: TextAlign.center),
          if (_lastAnswerCorrect != null) ...[
            const Divider(height: 24),
            Icon(
              _lastAnswerCorrect! ? Icons.check_circle : Icons.cancel,
              color: _lastAnswerCorrect! ? Colors.green : Colors.red,
              size: 40,
            ),
            Text(
              'Reconnu : "$_lastRecognizedText"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            if (_lastResponseTime != null)
              Text(
                'Temps de réponse : ${_lastResponseTime!.inMilliseconds} ms',
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 12),
          ],
          ElevatedButton(
            onPressed: () => setState(_goToNext),
            child: const Text('Suivant'),
          ),
          const SizedBox(height: 24),
          if (_resultsLog.isNotEmpty) _buildResultsSummary(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Récapitulatif visuel : un badge par item déjà testé, vert si la
  /// reconnaissance correspondait au mot attendu, rouge sinon (avec le texte
  /// reconnu, ex. "[unk]", pour comprendre pourquoi ça a échoué).
  Widget _buildResultsSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Récapitulatif de la session :',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _items
              .where((i) => _resultsLog.containsKey(i.displayLabel))
              .map((item) {
                final recognized = _resultsLog[item.displayLabel] ?? '';
                final ok = recognized.trim().toLowerCase() == item.spokenWord;
                return Chip(
                  backgroundColor: ok
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  label: Text(
                    '${item.displayLabel} → "$recognized"',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              })
              .toList(),
        ),
      ],
    );
  }
}
