import 'dart:math';

import '../models/question.dart';
import '../repositories/question_stats_repository.dart';
import 'question_selector.dart';

/// Implémentation réelle de la sélection adaptative (cf. PRD 6.5) :
/// - priorité absolue aux questions jamais pratiquées par ce profil sur cet
///   exercice, choisies aléatoirement parmi elles ;
/// - une fois toutes les questions vues au moins une fois, tirage aléatoire
///   pondéré par la moyenne des 3 derniers temps de réponse (plus ce temps
///   est long, plus la question revient souvent) ;
/// - jamais la même question deux fois de suite.
class AdaptiveQuestionSelector implements QuestionSelector {
  AdaptiveQuestionSelector(this._stats);

  final QuestionStatsRepository _stats;
  final _random = Random();

  @override
  Future<Question> selectNext({
    required String profileId,
    required String exerciseId,
    required List<Question> allQuestions,
    Question? previous,
  }) async {
    if (allQuestions.isEmpty) {
      throw ArgumentError('allQuestions ne doit pas être vide.');
    }
    if (allQuestions.length == 1) return allQuestions.first;

    final answeredIds = await _stats.answeredQuestionIds(
      profileId,
      exerciseId,
    );
    final unseen = allQuestions
        .where((q) => !answeredIds.contains(q.id))
        .toList();

    final pool = unseen.isNotEmpty ? unseen : allQuestions;
    final candidates = pool.length > 1
        ? pool.where((q) => q.id != previous?.id).toList()
        : pool;

    if (unseen.isNotEmpty) {
      return candidates[_random.nextInt(candidates.length)];
    }

    // Pondération par le temps moyen de réponse : les questions les plus
    // lentes ont un poids plus élevé, donc reviennent plus souvent.
    final weights = <Question, int>{};
    for (final question in candidates) {
      final avg = await _stats.averageResponseTime(
        profileId,
        exerciseId,
        question.id,
      );
      weights[question] = (avg?.inMilliseconds ?? 1).clamp(1, 1 << 30);
    }
    final totalWeight = weights.values.fold<int>(0, (a, b) => a + b);
    var roll = _random.nextInt(totalWeight);
    for (final entry in weights.entries) {
      if (roll < entry.value) return entry.key;
      roll -= entry.value;
    }
    return candidates.last;
  }
}
