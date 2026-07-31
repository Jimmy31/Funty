/// Les formes géométriques de l'exercice "Reconnaissance des formes"
/// (cf. PRD 5.1). La forme est **dessinée** à l'écran ; son nom n'est jamais
/// affiché pendant la question — l'écrire reviendrait à donner la réponse à
/// lire plutôt qu'une forme à reconnaître.
enum GeometricShape {
  cercle(label: 'cercle', spokenVariants: ['rond']),
  carre(label: 'carré'),
  triangle(label: 'triangle'),
  rectangle(label: 'rectangle'),
  losange(label: 'losange');

  const GeometricShape({required this.label, this.spokenVariants = const []});

  /// Nom de la forme : mot cible de la grammaire vocale (cf. PRD 6.2), texte
  /// de la révélation après 2 échecs, et libellé de la question dans les
  /// statistiques par question du parent (cf. PRD 6.6).
  final String label;

  /// Prononciations supplémentaires acceptées, sur le même principe que les
  /// homophones de lettres validés au spike (cf. PRD 12) : un enfant de PS
  /// dit "rond" bien plus souvent que "cercle", et le dire prouve qu'il a
  /// reconnu la forme. Tous ces mots sont présents dans le lexique du modèle
  /// Vosk français utilisé (vérifié dans sa table de symboles), contrairement
  /// à "zède" resté hors-vocabulaire pour la lettre Z.
  final List<String> spokenVariants;
}
