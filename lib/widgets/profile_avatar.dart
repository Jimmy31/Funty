import 'package:flutter/material.dart';

/// Avatar d'un profil enfant. Emoji pour l'instant (cf. PRD 6.1) — pas
/// encore de vraies illustrations.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.avatarId, this.radius = 28});

  final String avatarId;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Text(avatarId, style: TextStyle(fontSize: radius)),
    );
  }
}
