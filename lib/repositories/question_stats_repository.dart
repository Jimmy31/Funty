/// Historique des temps de réponse par question, au sein d'un exercice et
/// d'un profil (cf. PRD 6.4/6.5) — la granularité la plus fine du suivi de
/// performance, en dessous de l'agrégat par exercice (cf.
/// [PerformanceRepository]).
abstract class QuestionStatsRepository {
  /// [responseTime] est déjà la valeur à enregistrer telle quelle (pénalité
  /// de 5s déjà incluse si applicable, cf. PRD 6.5) — pas de logique de
  /// pénalité ici, uniquement le stockage.
  Future<void> recordAttempt(
    String profileId,
    String exerciseId,
    String questionId,
    Duration responseTime,
  );

  /// Identifiants des questions déjà pratiquées au moins une fois par ce
  /// profil sur cet exercice — sert à donner la priorité aux questions
  /// jamais vues (cf. PRD 6.5).
  Future<Set<String>> answeredQuestionIds(String profileId, String exerciseId);

  /// Moyenne des [sampleSize] dernières tentatives sur cette question
  /// précise, ou `null` si jamais pratiquée (cf. PRD 6.5, moyenne glissante
  /// sur les 3 dernières tentatives).
  Future<Duration?> averageResponseTime(
    String profileId,
    String exerciseId,
    String questionId, {
    int sampleSize = 3,
  });

  /// Temps de réponse moyen par question, sur l'historique complet (pas
  /// seulement les 3 dernières tentatives comme [averageResponseTime], qui
  /// sert à la sélection) — alimente les statistiques par question du
  /// tableau de bord parental (cf. PRD 6.6).
  Future<Map<String, Duration>> averageResponseTimeByQuestion(
    String profileId,
    String exerciseId,
  );
}
