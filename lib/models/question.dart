import 'geometric_shape.dart';

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
    this.objectCount,
    this.shape,
    this.spokenVariants,
  });

  final String id;
  final String exerciseId;

  /// Ce qui est affiché à l'enfant (ex. "H", "7", "7 + 3").
  final String displayValue;

  /// Pour le dénombrement : nombre d'objets à afficher et à compter. Null
  /// pour les exercices sans illustration (affichage texte via
  /// [displayValue]). La famille d'animaux et les images précises sont
  /// tirées au hasard par l'écran d'exercice à chaque présentation de la
  /// question, plutôt que figées ici (cf. [ExerciseRunnerScreen]).
  final int? objectCount;

  /// Pour la reconnaissance des formes : la forme géométrique à dessiner.
  /// Null pour les autres exercices. Quand elle est renseignée, l'écran
  /// d'exercice trace la forme et n'affiche **pas** [displayValue] — qui est
  /// justement le nom que l'enfant doit trouver, et qui ne sert donc plus
  /// qu'au parent (statistiques par question) et à la révélation après
  /// 2 échecs.
  final GeometricShape? shape;

  /// Mot cible pour la grammaire de reconnaissance vocale fermée (cf. spike
  /// technique) — null si l'exercice n'a pas de mode vocal pour cette
  /// question. Réutilise les homophones validés (H->"hache", M->"aime",
  /// N->"haine", X->"ixe") plutôt que l'orthographe "manuel scolaire".
  final String? expectedSpokenWord;

  /// Réponse attendue pour la validation tactile (ex. "10" pour "7 + 3").
  final String? expectedAnswer;

  /// Prononciations supplémentaires acceptées comme bonne réponse, en plus
  /// de [expectedSpokenWord] (cf. PRD 12) : certains mots courts sont rendus
  /// de façon instable par le modèle et méritent plusieurs formes valables.
  /// Ne change rien à ce que l'enfant doit dire — c'est une tolérance
  /// interne, comme les homophones de lettres.
  final List<String>? spokenVariants;

  /// Toutes les prononciations qui valident cette question. C'est aussi ce
  /// qui alimente la grammaire fermée soumise à Vosk (cf. PRD 6.2).
  List<String> get acceptedSpokenWords => [
    ?expectedSpokenWord,
    ...?spokenVariants,
  ];
}
