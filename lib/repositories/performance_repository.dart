import '../models/exercise_performance.dart';

/// Interface de persistance des performances. [recordAttempt] applique une
/// mise à jour simplifiée (pas le vrai calcul de badge du PRD 6.7) juste
/// pour que le tableau de bord bouge après avoir joué un exercice.
abstract class PerformanceRepository {
  Future<List<ExercisePerformanceStub>> getForProfile(String profileId);

  Future<ExercisePerformanceStub?> get(String profileId, String exerciseId);

  Future<void> recordAttempt(
    String profileId,
    String exerciseId, {
    required int badgeLevel,
  });

  /// Efface l'agrégat de ce profil sur cet exercice (cf. PRD 6.6, remise à
  /// zéro des statistiques) — accompagne l'effacement de l'historique par
  /// question, sans quoi le badge et le taux resteraient figés sur des
  /// données qui n'existent plus.
  Future<void> reset(String profileId, String exerciseId);
}
