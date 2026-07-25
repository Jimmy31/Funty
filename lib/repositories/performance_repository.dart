import '../data/catalog_seed.dart';
import '../models/exercise_performance.dart';

/// Interface de persistance des performances. Pour ce passage "squelette",
/// [recordAttempt] applique une mise à jour simplifiée (pas le vrai calcul
/// de badge du PRD 6.7) juste pour que le tableau de bord bouge après avoir
/// joué un exercice.
abstract class PerformanceRepository {
  Future<List<ExercisePerformanceStub>> getForProfile(String profileId);

  Future<ExercisePerformanceStub?> get(String profileId, String exerciseId);

  Future<void> recordAttempt(
    String profileId,
    String exerciseId, {
    required int badgeLevel,
  });
}

class InMemoryPerformanceRepository implements PerformanceRepository {
  InMemoryPerformanceRepository() : _stubs = buildPerformanceSeed().toList();

  final List<ExercisePerformanceStub> _stubs;

  @override
  Future<List<ExercisePerformanceStub>> getForProfile(
    String profileId,
  ) async {
    return List.unmodifiable(
      _stubs.where((s) => s.profileId == profileId),
    );
  }

  @override
  Future<ExercisePerformanceStub?> get(
    String profileId,
    String exerciseId,
  ) async {
    for (final stub in _stubs) {
      if (stub.profileId == profileId && stub.exerciseId == exerciseId) {
        return stub;
      }
    }
    return null;
  }

  @override
  Future<void> recordAttempt(
    String profileId,
    String exerciseId, {
    required int badgeLevel,
  }) async {
    final index = _stubs.indexWhere(
      (s) => s.profileId == profileId && s.exerciseId == exerciseId,
    );
    if (index == -1) {
      _stubs.add(
        ExercisePerformanceStub(
          profileId: profileId,
          exerciseId: exerciseId,
          badgeLevel: badgeLevel,
          successRatePercent: 100,
          attemptsCount: 1,
          lastPracticedAt: DateTime.now(),
        ),
      );
      return;
    }
    final existing = _stubs[index];
    _stubs[index] = existing.copyWith(
      badgeLevel: badgeLevel > existing.badgeLevel
          ? badgeLevel
          : existing.badgeLevel,
      attemptsCount: existing.attemptsCount + 1,
      lastPracticedAt: DateTime.now(),
    );
  }
}
