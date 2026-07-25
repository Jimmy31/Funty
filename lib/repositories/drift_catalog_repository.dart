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
  Future<List<Exercise>> getAllExercises() async =>
      List.unmodifiable(_exercises);

  @override
  Future<Exercise?> getExerciseById(String id) async {
    for (final exercise in _exercises) {
      if (exercise.id == id) return exercise;
    }
    return null;
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
            (t) => t.profileId.equals(profileId) & t.exerciseId.equals(exerciseId),
          ))
          .go();
    }
  }
}
