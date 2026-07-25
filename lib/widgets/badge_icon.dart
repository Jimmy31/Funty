import 'package:flutter/material.dart';

/// Représentation du niveau de récompense 0-3 (cf. PRD 6.7). Icône générique
/// pour l'instant — pas encore l'illustration "Grenouille à lunettes"
/// bronze/argent/or.
class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key, required this.level, this.size = 28});

  /// 0 = aucun badge, 1 = bronze, 2 = argent, 3 = or.
  final int level;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (level <= 0) {
      return Icon(
        Icons.circle_outlined,
        size: size,
        color: Colors.grey.shade400,
      );
    }
    final color = switch (level) {
      1 => Colors.brown.shade400,
      2 => Colors.blueGrey.shade300,
      _ => Colors.amber.shade600,
    };
    return Icon(Icons.emoji_events, size: size, color: color);
  }
}
