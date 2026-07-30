/// Pénalité appliquée à une tentative ratée dans le calcul du temps moyen
/// (cf. PRD 6.6) : elle ne compte pas pour le temps réellement mis, sinon
/// une mauvaise réponse donnée très vite passerait pour une réussite
/// éclatante. On lui attribue le seuil bronze de l'exercice plus 10
/// secondes, c'est-à-dire nettement au-delà de la dernière médaille.
Duration failedAttemptTime(Duration bronzeThreshold) =>
    bronzeThreshold + const Duration(seconds: 10);

/// Résultat par question sur les dernières tentatives (cf. PRD 6.6) : le
/// temps de réponse moyen, une mauvaise réponse comptant pour
/// [failedAttemptTime].
class QuestionTiming {
  const QuestionTiming({required this.attempts, required this.average});

  /// Tentatives prises en compte (au plus `sampleSize`). Vaut 0 pour une
  /// question jamais posée, qui s'affiche alors "N/A" et ne compte pas dans
  /// les moyennes.
  final int attempts;

  /// Temps moyen sur ces tentatives, ou `null` si la question n'a jamais été
  /// posée.
  final Duration? average;

  bool get hasData => attempts > 0 && average != null;
}

/// Une tentative telle que lue en base, réduite à ce dont le calcul a besoin.
class AttemptRecord {
  const AttemptRecord({
    required this.questionId,
    required this.responseTime,
    required this.correct,
  });

  final String questionId;
  final Duration responseTime;
  final bool correct;
}

/// Calcule le temps moyen par question à partir des tentatives **triées de
/// la plus récente à la plus ancienne** : pour chaque question, seules les
/// [sampleSize] premières rencontrées sont retenues, une tentative ratée
/// comptant pour [failedAttemptTime] plutôt que pour son temps réel.
///
/// Séparé de l'accès à la base pour être vérifiable directement (cf.
/// test/question_stats_test.dart) : c'est ici que se logent les deux règles
/// faciles à casser, la fenêtre glissante et la substitution des échecs.
Map<String, QuestionTiming> aggregateRecentTimings(
  Iterable<AttemptRecord> attemptsNewestFirst, {
  required Duration bronzeThreshold,
  required int sampleSize,
}) {
  final failedMs = failedAttemptTime(bronzeThreshold).inMilliseconds;
  final counted = <String, int>{};
  final totalMs = <String, int>{};
  for (final attempt in attemptsNewestFirst) {
    final seen = counted[attempt.questionId] ?? 0;
    if (seen >= sampleSize) continue;
    counted[attempt.questionId] = seen + 1;
    final effectiveMs = attempt.correct
        ? attempt.responseTime.inMilliseconds
        : failedMs;
    totalMs[attempt.questionId] =
        (totalMs[attempt.questionId] ?? 0) + effectiveMs;
  }
  return {
    for (final entry in counted.entries)
      entry.key: QuestionTiming(
        attempts: entry.value,
        average: Duration(
          milliseconds: (totalMs[entry.key] ?? 0) ~/ entry.value,
        ),
      ),
  };
}

/// Historique des tentatives par question, au sein d'un exercice et d'un
/// profil (cf. PRD 6.4/6.5) — la granularité la plus fine du suivi de
/// performance, en dessous de l'agrégat par exercice (cf.
/// [PerformanceRepository]).
abstract class QuestionStatsRepository {
  /// [responseTime] est déjà la valeur à enregistrer telle quelle (pénalité
  /// de 5s déjà incluse si applicable, cf. PRD 6.5) — pas de logique de
  /// pénalité ici, uniquement le stockage. [correct] distingue une bonne
  /// réponse d'une réponse révélée après 2 échecs (cf. PRD 6.2).
  Future<void> recordAttempt(
    String profileId,
    String exerciseId,
    String questionId,
    Duration responseTime, {
    required bool correct,
  });

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
  /// sert à la sélection).
  Future<Map<String, Duration>> averageResponseTimeByQuestion(
    String profileId,
    String exerciseId,
  );

  /// Temps de réponse moyen par question sur les [sampleSize] dernières
  /// tentatives (cf. PRD 6.6). Une tentative ratée compte pour
  /// [failedAttemptTime] plutôt que pour son temps réel, d'où le besoin de
  /// [bronzeThreshold] — passé en paramètre plutôt que lu ici, car il est
  /// réglable par le parent (cf. PRD 6.7) : l'historique est donc réévalué
  /// avec le seuil courant.
  ///
  /// Les questions jamais posées sont absentes du résultat : c'est à
  /// l'appelant de les afficher "N/A" en les excluant des moyennes.
  Future<Map<String, QuestionTiming>> recentTimingByQuestion(
    String profileId,
    String exerciseId, {
    required Duration bronzeThreshold,
    int sampleSize = 5,
  });

  /// Efface tout l'historique de ce profil sur cet exercice (cf. PRD 6.6,
  /// remise à zéro des statistiques).
  Future<void> resetExercise(String profileId, String exerciseId);
}
