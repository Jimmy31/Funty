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
    Duration responseTime,
  ) async {
    await _db
        .into(_db.questionAttempts)
        .insert(
          QuestionAttemptsCompanion.insert(
            profileId: profileId,
            exerciseId: exerciseId,
            questionId: questionId,
            responseTimeMs: responseTime.inMilliseconds,
            attemptedAt: DateTime.now(),
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
}
