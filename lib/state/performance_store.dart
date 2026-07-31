import 'package:flutter/foundation.dart';

import '../models/exercise_performance.dart';
import '../repositories/performance_repository.dart';

class PerformanceStore extends ChangeNotifier {
  PerformanceStore(this._repository);

  final PerformanceRepository _repository;
  final Map<String, List<ExercisePerformanceStub>> _cache = {};
  int _revision = 0;

  /// Incrémenté à chaque écriture. Les écrans qui lisent l'historique par
  /// *question* (cf. [QuestionStatsRepository]) n'ont aucun autre moyen de
  /// savoir qu'il a changé : ce dépôt-là n'est pas observable, et une remise à
  /// zéro les laisserait afficher des chiffres périmés. Comparer la révision
  /// leur dit quand relancer leur requête.
  int get revision => _revision;

  List<ExercisePerformanceStub> forProfile(String profileId) =>
      _cache[profileId] ?? const [];

  Future<void> ensureLoaded(String profileId) async {
    if (_cache.containsKey(profileId)) return;
    _cache[profileId] = await _repository.getForProfile(profileId);
    _revision++;
    notifyListeners();
  }

  Future<void> recordAttempt(
    String profileId,
    String exerciseId, {
    required int badgeLevel,
  }) async {
    await _repository.recordAttempt(
      profileId,
      exerciseId,
      badgeLevel: badgeLevel,
    );
    _cache[profileId] = await _repository.getForProfile(profileId);
    _revision++;
    notifyListeners();
  }

  /// Remet à zéro l'agrégat de cet exercice (cf. PRD 6.6). L'historique par
  /// question est effacé séparément, via [QuestionStatsRepository].
  Future<void> reset(String profileId, String exerciseId) async {
    await _repository.reset(profileId, exerciseId);
    _cache[profileId] = await _repository.getForProfile(profileId);
    _revision++;
    notifyListeners();
  }
}
