import 'package:drift/drift.dart';

import '../data/database.dart';
import 'question_stats_repository.dart';

class DriftQuestionStatsRepository implements QuestionStatsRepository {
  DriftQuestionStatsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> recordAttempt(
    String profileId,
    String exerciseId,
    String questionId,
    Duration responseTime, {
    required bool correct,
  }) async {
    await _db
        .into(_db.questionAttempts)
        .insert(
          QuestionAttemptsCompanion.insert(
            profileId: profileId,
            exerciseId: exerciseId,
            questionId: questionId,
            responseTimeMs: responseTime.inMilliseconds,
            attemptedAt: DateTime.now(),
            correct: Value(correct),
          ),
        );
  }

  @override
  Future<Set<String>> answeredQuestionIds(
    String profileId,
    String exerciseId,
  ) async {
    final query = _db.selectOnly(_db.questionAttempts, distinct: true)
      ..addColumns([_db.questionAttempts.questionId])
      ..where(
        _db.questionAttempts.profileId.equals(profileId) &
            _db.questionAttempts.exerciseId.equals(exerciseId),
      );
    final rows = await query.get();
    return rows
        .map((row) => row.read(_db.questionAttempts.questionId)!)
        .toSet();
  }

  @override
  Future<Duration?> averageResponseTime(
    String profileId,
    String exerciseId,
    String questionId, {
    int sampleSize = 3,
  }) async {
    final query = _db.select(_db.questionAttempts)
      ..where(
        (t) =>
            t.profileId.equals(profileId) &
            t.exerciseId.equals(exerciseId) &
            t.questionId.equals(questionId),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.attemptedAt)])
      ..limit(sampleSize);
    final rows = await query.get();
    if (rows.isEmpty) return null;
    final totalMs = rows.fold<int>(0, (sum, row) => sum + row.responseTimeMs);
    return Duration(milliseconds: totalMs ~/ rows.length);
  }

  @override
  Future<Map<String, Duration>> averageResponseTimeByQuestion(
    String profileId,
    String exerciseId,
  ) async {
    final avgExpr = _db.questionAttempts.responseTimeMs.avg();
    final query = _db.selectOnly(_db.questionAttempts)
      ..addColumns([_db.questionAttempts.questionId, avgExpr])
      ..where(
        _db.questionAttempts.profileId.equals(profileId) &
            _db.questionAttempts.exerciseId.equals(exerciseId),
      )
      ..groupBy([_db.questionAttempts.questionId]);
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(_db.questionAttempts.questionId)!: Duration(
          milliseconds: (row.read(avgExpr) ?? 0).round(),
        ),
    };
  }

  @override
  Future<Map<String, QuestionTiming>> recentTimingByQuestion(
    String profileId,
    String exerciseId, {
    required Duration bronzeThreshold,
    int sampleSize = 5,
  }) async {
    // "Les N dernières par question" se dirait en SQL avec une fonction de
    // fenêtrage ; le regroupement est fait en Dart, bien plus lisible et sans
    // coût réel ici (l'historique d'un enfant sur un exercice reste petit).
    // Les lignes antérieures au suivi de la justesse (`correct` nul) sont
    // écartées : sans savoir si la tentative était juste, on ne peut pas
    // décider si son temps compte tel quel ou s'il faut lui substituer la
    // pénalité d'échec.
    final query = _db.select(_db.questionAttempts)
      ..where(
        (t) =>
            t.profileId.equals(profileId) &
            t.exerciseId.equals(exerciseId) &
            t.correct.isNotNull(),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.attemptedAt)]);
    final rows = await query.get();

    return aggregateRecentTimings(
      rows.map(
        (row) => AttemptRecord(
          questionId: row.questionId,
          responseTime: Duration(milliseconds: row.responseTimeMs),
          correct: row.correct ?? false,
        ),
      ),
      bronzeThreshold: bronzeThreshold,
      sampleSize: sampleSize,
    );
  }

  @override
  Future<void> resetExercise(String profileId, String exerciseId) async {
    await (_db.delete(_db.questionAttempts)..where(
          (t) =>
              t.profileId.equals(profileId) & t.exerciseId.equals(exerciseId),
        ))
        .go();
  }
}
