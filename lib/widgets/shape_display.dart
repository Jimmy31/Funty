import 'package:flutter/material.dart';

import '../models/geometric_shape.dart';

/// Dessine la forme géométrique à reconnaître (cf. PRD 5.1). Tracé vectoriel
/// plutôt qu'images : une forme géométrique se décrit exactement, reste nette
/// à n'importe quelle taille d'écran, et permet de faire varier la couleur
/// d'une question à l'autre sans multiplier les fichiers.
class ShapeDisplay extends StatelessWidget {
  const ShapeDisplay({
    super.key,
    required this.shape,
    required this.color,
    this.portrait = false,
  });

  final GeometricShape shape;
  final Color color;

  /// Rectangle debout / losange plus haut que large (cf. ShapePresentation).
  final bool portrait;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ShapePainter(shape: shape, color: color, portrait: portrait),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter({
    required this.shape,
    required this.color,
    required this.portrait,
  });

  final GeometricShape shape;
  final Color color;
  final bool portrait;

  /// Le contour est simplement une version assombrie du remplissage : il
  /// détache la forme du fond blanc même pour un jaune très clair, et rend
  /// les sommets nets là où le seul aplat les laisserait mous.
  Color get _outlineColor {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.22).clamp(0.0, 1.0)).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Toutes les proportions sont exprimées par rapport au côté du plus grand
    // carré tenant dans la zone : la forme garde ainsi les mêmes proportions
    // quelle que soit la place que l'écran lui laisse.
    final side = size.shortestSide;
    final center = Offset(size.width / 2, size.height / 2);
    final path = _buildPath(center, side);

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = side * 0.035
      ..strokeJoin = StrokeJoin.round
      ..color = _outlineColor;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, outline);
  }

  Path _buildPath(Offset center, double side) {
    switch (shape) {
      case GeometricShape.cercle:
        return Path()
          ..addOval(Rect.fromCircle(center: center, radius: side * 0.42));

      case GeometricShape.carre:
        return Path()
          ..addRect(
            Rect.fromCenter(
              center: center,
              width: side * 0.76,
              height: side * 0.76,
            ),
          );

      case GeometricShape.rectangle:
        // Nettement plus long que large : un rectangle presque carré se
        // confondrait avec le carré, qui est justement l'autre forme à
        // quatre angles droits de l'exercice.
        final long = side * 0.92;
        final short = side * 0.52;
        return Path()
          ..addRect(
            Rect.fromCenter(
              center: center,
              width: portrait ? short : long,
              height: portrait ? long : short,
            ),
          );

      case GeometricShape.triangle:
        // Triangle isocèle pointe en haut, la forme canonique attendue à ce
        // niveau. Pas de rotation aléatoire : une pointe en bas se lit
        // encore comme un triangle, mais brouille inutilement le repère.
        final halfBase = side * 0.44;
        final halfHeight = side * 0.39;
        return Path()
          ..moveTo(center.dx, center.dy - halfHeight)
          ..lineTo(center.dx + halfBase, center.dy + halfHeight)
          ..lineTo(center.dx - halfBase, center.dy + halfHeight)
          ..close();

      case GeometricShape.losange:
        // Diagonales volontairement inégales : un losange à diagonales
        // égales est un carré posé sur la pointe, et les deux réponses
        // deviendraient défendables.
        final longHalf = side * 0.46;
        final shortHalf = side * 0.32;
        final halfWidth = portrait ? shortHalf : longHalf;
        final halfHeight = portrait ? longHalf : shortHalf;
        return Path()
          ..moveTo(center.dx, center.dy - halfHeight)
          ..lineTo(center.dx + halfWidth, center.dy)
          ..lineTo(center.dx, center.dy + halfHeight)
          ..lineTo(center.dx - halfWidth, center.dy)
          ..close();
    }
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.color != color ||
        oldDelegate.portrait != portrait;
  }
}
