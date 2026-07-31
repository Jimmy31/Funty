import 'dart:math';
import 'dart:ui';

/// Palette de tracé des formes géométriques (cf. PRD 5.1) — des couleurs
/// franches et bien distinctes, dans l'esprit des illustrations enfantines.
const shapePalette = <Color>[
  Color(0xFFE53935), // rouge
  Color(0xFFFB8C00), // orange
  Color(0xFFFDD835), // jaune
  Color(0xFF43A047), // vert
  Color(0xFF00ACC1), // cyan
  Color(0xFF1E88E5), // bleu
  Color(0xFF8E24AA), // violet
  Color(0xFFD81B60), // rose
];

/// Comment une forme est présentée pour une question donnée (cf.
/// [randomShapePresentation]) — l'équivalent, côté formes, de
/// [LetterPresentation] pour l'Alphabet.
class ShapePresentation {
  const ShapePresentation({required this.color, required this.portrait});

  final Color color;

  /// Oriente les formes qui ont un sens : rectangle debout plutôt que
  /// couché, losange plus haut que large plutôt que l'inverse. Sans effet
  /// sur le cercle, le carré et le triangle — les tourner ne changerait
  /// rien (cercle), ou les ferait passer pour une autre forme (un carré
  /// posé sur la pointe *est* un losange, cf. [ShapeDisplay]).
  final bool portrait;
}

/// Tire une présentation pour la prochaine forme. La couleur est aléatoire
/// **par question** et jamais deux fois la même de suite ([avoid]) : figer
/// une couleur par forme donnerait à l'enfant un raccourci ("la bleue, c'est
/// le carré") qui court-circuite justement ce que l'exercice évalue.
ShapePresentation randomShapePresentation(Random random, {Color? avoid}) {
  var color = shapePalette[random.nextInt(shapePalette.length)];
  while (color == avoid) {
    color = shapePalette[random.nextInt(shapePalette.length)];
  }
  return ShapePresentation(color: color, portrait: random.nextBool());
}
