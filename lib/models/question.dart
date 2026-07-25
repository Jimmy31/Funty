/// Une question individuelle au sein d'un exercice (cf. granularité
/// "question", PRD 6.2) — ex. une lettre précise de l'exercice Alphabet, une
/// paire précise de l'exercice Addition.
class Question {
  const Question({
    required this.id,
    required this.exerciseId,
    required this.displayValue,
    this.expectedSpokenWord,
    this.expectedAnswer,
  });

  final String id;
  final String exerciseId;

  /// Ce qui est affiché à l'enfant (ex. "H", "7", "7 + 3").
  final String displayValue;

  /// Mot cible pour la grammaire de reconnaissance vocale fermée (cf. spike
  /// technique) — null si l'exercice n'a pas de mode vocal pour cette
  /// question. Réutilise les homophones validés (H->"hache", M->"aime",
  /// N->"haine", X->"ixe") plutôt que l'orthographe "manuel scolaire".
  final String? expectedSpokenWord;

  /// Réponse attendue pour la validation tactile (ex. "10" pour "7 + 3").
  final String? expectedAnswer;
}
