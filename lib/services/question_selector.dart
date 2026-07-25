import 'dart:math';

import '../models/question.dart';

/// Sélectionne la prochaine question au sein d'un exercice. Interface pour
/// pouvoir brancher plus tard le vrai algorithme de sélection adaptative
/// (PRD 6.5 : priorité aux questions jamais vues choisies aléatoirement,
/// puis moyenne des 3 dernières tentatives, jamais deux fois de suite) sans
/// toucher à l'écran d'exercice.
abstract class QuestionSelector {
  Question selectNext(List<Question> allQuestions, Question? previous);
}

/// Implémentation triviale pour ce passage "squelette" : aléatoire, en
/// respectant uniquement la contrainte de non-répétition immédiate
/// (cf. PRD 6.5) — pas encore de priorité aux questions jamais vues ni de
/// pondération par temps de réponse.
class RandomQuestionSelector implements QuestionSelector {
  final _random = Random();

  @override
  Question selectNext(List<Question> allQuestions, Question? previous) {
    if (allQuestions.isEmpty) {
      throw ArgumentError('allQuestions ne doit pas être vide.');
    }
    if (allQuestions.length == 1) return allQuestions.first;
    Question next;
    do {
      next = allQuestions[_random.nextInt(allQuestions.length)];
    } while (previous != null && next.id == previous.id);
    return next;
  }
}
