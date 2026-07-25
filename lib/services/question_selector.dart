import '../models/question.dart';

/// Sélectionne la prochaine question au sein d'un exercice (cf. PRD 6.5).
/// `profileId`/`exerciseId` permettent à une implémentation réelle de
/// consulter l'historique de réponse propre à ce couple profil/exercice.
abstract class QuestionSelector {
  Future<Question> selectNext({
    required String profileId,
    required String exerciseId,
    required List<Question> allQuestions,
    Question? previous,
  });
}
