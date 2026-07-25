import 'package:flutter/foundation.dart';

import '../models/exercise_performance.dart';
import '../repositories/performance_repository.dart';

class PerformanceStore extends ChangeNotifier {
  PerformanceStore(this._repository);

  final PerformanceRepository _repository;
  final Map<String, List<ExercisePerformanceStub>> _cache = {};

  List<ExercisePerformanceStub> forProfile(String profileId) =>
      _cache[profileId] ?? const [];

  Future<void> ensureLoaded(String profileId) async {
    if (_cache.containsKey(profileId)) return;
    _cache[profileId] = await _repository.getForProfile(profileId);
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
    notifyListeners();
  }
}
