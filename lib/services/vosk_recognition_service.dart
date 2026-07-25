import 'dart:convert';

import 'package:vosk_flutter_service/vosk_flutter_service.dart';

/// Service de reconnaissance vocale hors-ligne, extrait du spike technique
/// qui a validé ce mécanisme sur l'appareil (cf. docs/PRD.md section 12).
/// Reconnaissance d'un mot isolé restreinte à une grammaire fermée
/// (cf. PRD 6.2) — pas de reconnaissance de phrase libre.
class VoskRecognitionService {
  static const _modelAsset = 'assets/models/vosk-model-small-fr-0.22.zip';
  static const _sampleRate = 16000;

  final _vosk = VoskFlutterPlugin.instance();
  final _modelLoader = ModelLoader();

  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  bool get isReady => _speechService != null;

  /// Charge le modèle et initialise le service d'écoute. À appeler une seule
  /// fois avant [setGrammar]/[start]. Prend quelques secondes la première
  /// fois (extraction du zip).
  Future<void> initialize() async {
    final modelPath = await _modelLoader.loadFromAssets(_modelAsset);
    _model = await _vosk.createModel(modelPath);
    _recognizer = await _vosk.createRecognizer(
      model: _model!,
      sampleRate: _sampleRate,
      grammar: const ['[unk]'],
    );
    _speechService = await _vosk.initSpeechService(_recognizer!);
  }

  /// Restreint la reconnaissance aux mots donnés (+ le "[unk]" de secours,
  /// convention Vosk pour "hors grammaire"). À appeler avant chaque question,
  /// avec le seul mot attendu pour cette question précise.
  Future<void> setGrammar(List<String> words) async {
    if (_recognizer == null) {
      throw StateError('VoskRecognitionService.initialize() non appelé.');
    }
    await _recognizer!.setGrammar([...words, '[unk]']);
  }

  Stream<String> partialResults() {
    if (_speechService == null) {
      throw StateError('VoskRecognitionService.initialize() non appelé.');
    }
    return _speechService!.onPartial().map((json) => _extractText(json, 'partial'));
  }

  Stream<String> finalResults() {
    if (_speechService == null) {
      throw StateError('VoskRecognitionService.initialize() non appelé.');
    }
    return _speechService!.onResult().map((json) => _extractText(json, 'text'));
  }

  Future<void> start() async {
    await _speechService?.start();
  }

  Future<void> stop() async {
    await _speechService?.stop();
  }

  Future<void> dispose() async {
    await _speechService?.dispose();
    await _recognizer?.dispose();
    _model?.dispose();
    _speechService = null;
    _recognizer = null;
    _model = null;
  }

  String _extractText(String json, String key) {
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return (decoded[key] as String?)?.trim() ?? '';
    } catch (_) {
      return '';
    }
  }
}
