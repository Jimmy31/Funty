import '../models/exercise.dart';

/// Interface de persistance du catalogue et de l'activation par profil
/// (cf. PRD 6.2/6.3). Le catalogue est partagé entre tous les profils ; ce
/// qui varie par profil, c'est l'activation, pas le contenu.
abstract class CatalogRepository {
  Future<List<Exercise>> getAllExercises();

  Future<Exercise?> getExerciseById(String id);

  Future<Set<String>> getActiveExerciseIds(String profileId);

  Future<void> setActive(String profileId, String exerciseId, bool active);

  /// Réglage parental propre à un exercice (cf. PRD 6.6/6.7) : s'applique à
  /// tous les profils de l'appareil pratiquant cet exercice.
  Future<void> updateExerciseSettings(
    String exerciseId, {
    required int questionsPerSeries,
    required Duration bronzeThreshold,
    required Duration silverThreshold,
    required Duration goldThreshold,
  });
}
