import 'package:flutter_test/flutter_test.dart';
import 'package:funty/repositories/question_stats_repository.dart';

/// Vérifie les deux règles de calcul des statistiques par question (cf. PRD
/// 6.6) : la fenêtre des N dernières tentatives, et la substitution du temps
/// d'une tentative ratée par le seuil bronze majoré de 10 secondes.
void main() {
  const bronze = Duration(seconds: 7);
  final failed = failedAttemptTime(bronze); // 17 s

  AttemptRecord attempt(
    String questionId,
    int seconds, {
    bool correct = true,
  }) => AttemptRecord(
    questionId: questionId,
    responseTime: Duration(seconds: seconds),
    correct: correct,
  );

  Map<String, QuestionTiming> aggregate(
    List<AttemptRecord> newestFirst, {
    int sampleSize = 5,
  }) => aggregateRecentTimings(
    newestFirst,
    bronzeThreshold: bronze,
    sampleSize: sampleSize,
  );

  test('une tentative ratée compte pour bronze + 10 s', () {
    expect(failed, const Duration(seconds: 17));

    final stats = aggregate([attempt('q1', 1, correct: false)]);

    // Le temps réel (1 s) est ignoré : une mauvaise réponse rapide ne doit
    // pas se lire comme une performance.
    expect(stats['q1']!.average, failed);
    expect(stats['q1']!.attempts, 1);
  });

  test('mélange réussite et échec dans la moyenne', () {
    final stats = aggregate([
      attempt('q1', 3),
      attempt('q1', 5, correct: false),
    ]);

    // (3 s + 17 s) / 2
    expect(stats['q1']!.average, const Duration(seconds: 10));
    expect(stats['q1']!.attempts, 2);
  });

  test('ne retient que les N tentatives les plus récentes', () {
    final stats = aggregate([
      // Les 5 plus récentes, toutes à 2 s.
      for (var i = 0; i < 5; i++) attempt('q1', 2),
      // Les plus anciennes, très lentes, doivent être ignorées.
      for (var i = 0; i < 5; i++) attempt('q1', 60),
    ]);

    expect(stats['q1']!.attempts, 5);
    expect(stats['q1']!.average, const Duration(seconds: 2));
  });

  test('compte les tentatives séparément par question', () {
    final stats = aggregate([
      attempt('q1', 2),
      attempt('q2', 8),
      attempt('q1', 4),
    ]);

    expect(stats['q1']!.attempts, 2);
    expect(stats['q1']!.average, const Duration(seconds: 3));
    expect(stats['q2']!.attempts, 1);
    expect(stats['q2']!.average, const Duration(seconds: 8));
  });

  test('une question jamais posée est absente du résultat', () {
    final stats = aggregate([attempt('q1', 2)]);

    expect(stats.containsKey('q2'), isFalse);
    // L'écran l'affichera "N/A" et l'exclura des moyennes.
    expect(stats['q2']?.average, isNull);
  });

  test('rend une carte vide sans tentative', () {
    expect(aggregate(const []), isEmpty);
  });

  test('respecte une taille de fenêtre personnalisée', () {
    final stats = aggregate([
      attempt('q1', 2),
      attempt('q1', 4),
      attempt('q1', 60),
    ], sampleSize: 2);

    expect(stats['q1']!.attempts, 2);
    expect(stats['q1']!.average, const Duration(seconds: 3));
  });
}
