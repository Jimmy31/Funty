import 'package:drift/drift.dart';

import '../data/database.dart';
import '../models/exercise_performance.dart';
import 'performance_repository.dart';

class DriftPerformanceRepository implements PerformanceRepository {
  DriftPerformanceRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<ExercisePerformanceStub>> getForProfile(String profileId) async {
    final rows = await (_db.select(
      _db.performances,
    )..where((t) => t.profileId.equals(profileId))).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<ExercisePerformanceStub?> get(
    String profileId,
    String exerciseId,
  ) async {
    final row =
        await (_db.select(_db.performances)..where(
              (t) =>
                  t.profileId.equals(profileId) &
                  t.exerciseId.equals(exerciseId),
            ))
            .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<void> recordAttempt(
    String profileId,
    String exerciseId, {
    required int badgeLevel,
  }) async {
    final existing = await get(profileId, exerciseId);
    final updated = existing == null
        ? ExercisePerformanceStub(
            profileId: profileId,
            exerciseId: exerciseId,
            badgeLevel: badgeLevel,
            successRatePercent: 100,
            attemptsCount: 1,
            lastPracticedAt: DateTime.now(),
          )
        : existing.copyWith(
            badgeLevel: badgeLevel > existing.badgeLevel
                ? badgeLevel
                : existing.badgeLevel,
            attemptsCount: existing.attemptsCount + 1,
            lastPracticedAt: DateTime.now(),
          );
    await _db
        .into(_db.performances)
        .insertOnConflictUpdate(
          PerformancesCompanion.insert(
            profileId: updated.profileId,
            exerciseId: updated.exerciseId,
            badgeLevel: updated.badgeLevel,
            successRatePercent: updated.successRatePercent,
            attemptsCount: updated.attemptsCount,
            lastPracticedAt: Value(updated.lastPracticedAt),
          ),
        );
  }

  @override
  Future<void> reset(String profileId, String exerciseId) async {
    // La ligne est remise à zéro plutôt que supprimée : l'exercice reste
    // ainsi visible dans le tableau de bord, où le parent peut consulter le
    // tableau des questions (toutes en "N/A") et voir la remise à zéro
    // prendre effet.
    await (_db.update(_db.performances)..where(
          (t) =>
              t.profileId.equals(profileId) & t.exerciseId.equals(exerciseId),
        ))
        .write(
          const PerformancesCompanion(
            badgeLevel: Value(0),
            successRatePercent: Value(0),
            attemptsCount: Value(0),
            lastPracticedAt: Value(null),
          ),
        );
  }

  ExercisePerformanceStub _toModel(PerformanceRow row) =>
      ExercisePerformanceStub(
        profileId: row.profileId,
        exerciseId: row.exerciseId,
        badgeLevel: row.badgeLevel,
        successRatePercent: row.successRatePercent,
        attemptsCount: row.attemptsCount,
        lastPracticedAt: row.lastPracticedAt,
      );
}
