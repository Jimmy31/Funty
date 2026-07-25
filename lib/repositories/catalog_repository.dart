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
