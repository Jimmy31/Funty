import 'package:flutter/material.dart';

/// Représentation du niveau de récompense 0-3 (cf. PRD 6.7) : une coupe
/// bronze/argent/or, illustration découpée de `docs/graphics/Coupes.png` par
/// `python tool/generate_badge_icons.py`.
///
/// Le niveau 0 reste un simple cercle vide : c'est l'absence de récompense,
/// pas une quatrième récompense, et une coupe grisée se lirait comme un
/// trophée terne plutôt que comme un emplacement à remplir.
class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key, required this.level, this.size = 28});

  /// 0 = aucun badge, 1 = bronze, 2 = argent, 3 = or.
  final int level;
  final double size;

  static const _assetByLevel = {
    1: 'assets/images/badges/badge_bronze.png',
    2: 'assets/images/badges/badge_argent.png',
    3: 'assets/images/badges/badge_or.png',
  };

  @override
  Widget build(BuildContext context) {
    final asset = _assetByLevel[level];
    if (asset == null) {
      return Icon(
        Icons.circle_outlined,
        size: size,
        color: Colors.grey.shade400,
      );
    }
    return Image.asset(asset, width: size, height: size);
  }
}
