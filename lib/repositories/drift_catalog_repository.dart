import 'package:drift/drift.dart';

import '../data/catalog_seed.dart';
import '../data/database.dart';
import '../models/exercise.dart';
import 'catalog_repository.dart';

/// Le contenu du catalogue (exercices/questions) reste défini en code — pas
/// éditable par le parent (cf. PRD 8.1, thèmes amenés à grandir par
/// développement, pas par saisie utilisateur). Seule l'activation par profil
/// est propre à l'utilisateur et vit en base.
class DriftCatalogRepository implements CatalogRepository {
  DriftCatalogRepository(this._db) : _exercises = buildCatalogSeed();

  final AppDatabase _db;
  final List<Exercise> _exercises;

  @override
  Future<List<Exercise>> getAllExercises() async {
    final overrides = await _loadOverrides();
    if (overrides.isEmpty) return List.unmodifiable(_exercises);
    return List.unmodifiable(
      _exercises.map((exercise) {
        final override = overrides[exercise.id];
        if (override == null) return exercise;
        return exercise.copyWith(
          questionsPerSeries: override.questionsPerSeries,
          bronzeThreshold: Duration(milliseconds: override.bronzeThresholdMs),
          silverThreshold: Duration(milliseconds: override.silverThresholdMs),
          goldThreshold: Duration(milliseconds: override.goldThresholdMs),
        );
      }),
    );
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    final exercises = await getAllExercises();
    for (final exercise in exercises) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  Future<Map<String, ExerciseSettingsRow>> _loadOverrides() async {
    final rows = await _db.select(_db.exerciseSettings).get();
    return {for (final row in rows) row.exerciseId: row};
  }

  @override
  Future<Set<String>> getActiveExerciseIds(String profileId) async {
    final rows = await (_db.select(
      _db.activations,
    )..where((t) => t.profileId.equals(profileId))).get();
    return rows.map((row) => row.exerciseId).toSet();
  }

  @override
  Future<void> setActive(
    String profileId,
    String exerciseId,
    bool active,
  ) async {
    if (active) {
      await _db
          .into(_db.activations)
          .insertOnConflictUpdate(
            ActivationsCompanion.insert(
              profileId: profileId,
              exerciseId: exerciseId,
            ),
          );
    } else {
      await (_db.delete(_db.activations)..where(
            (t) =>
                t.profileId.equals(profileId) & t.exerciseId.equals(exerciseId),
          ))
          .go();
    }
  }

  @override
  Future<void> updateExerciseSettings(
    String exerciseId, {
    required int questionsPerSeries,
    required Duration bronzeThreshold,
    required Duration silverThreshold,
    required Duration goldThreshold,
  }) async {
    await _db
        .into(_db.exerciseSettings)
        .insertOnConflictUpdate(
          ExerciseSettingsCompanion.insert(
            exerciseId: exerciseId,
            questionsPerSeries: questionsPerSeries,
            bronzeThresholdMs: bronzeThreshold.inMilliseconds,
            silverThresholdMs: silverThreshold.inMilliseconds,
            goldThresholdMs: goldThreshold.inMilliseconds,
          ),
        );
  }
}
