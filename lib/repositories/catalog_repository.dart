import '../data/catalog_seed.dart';
import '../models/exercise.dart';

/// Interface de persistance du catalogue et de l'activation par profil
/// (cf. PRD 6.2/6.3). Le catalogue est partagé entre tous les profils ; ce
/// qui varie par profil, c'est l'activation, pas le contenu.
abstract class CatalogRepository {
  Future<List<Exercise>> getAllExercises();

  Future<Exercise?> getExerciseById(String id);

  Future<Set<String>> getActiveExerciseIds(String profileId);

  Future<void> setActive(String profileId, String exerciseId, bool active);
}

class InMemoryCatalogRepository implements CatalogRepository {
  InMemoryCatalogRepository()
    : _exercises = buildCatalogSeed(),
      _activationByProfile = {
        // Quelques activations de départ pour que les profils seedés
        // n'aient pas une vue enfant vide (cf. catalog_seed.dart).
        'profile-demo-1': {
          'ex-nombres',
          'ex-alphabet-majuscule-standard',
          'ex-comptage',
        },
        'profile-demo-2': {'ex-formes', 'ex-alphabet-majuscule-standard'},
      };

  final List<Exercise> _exercises;
  final Map<String, Set<String>> _activationByProfile;

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
    return Set.unmodifiable(_activationByProfile[profileId] ?? const {});
  }

  @override
  Future<void> setActive(
    String profileId,
    String exerciseId,
    bool active,
  ) async {
    final set = _activationByProfile.putIfAbsent(profileId, () => {});
    if (active) {
      set.add(exerciseId);
    } else {
      set.remove(exerciseId);
    }
  }
}
