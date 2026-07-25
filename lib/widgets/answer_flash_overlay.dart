import 'package:flutter/material.dart';

/// Flash bref vert/rouge en surimpression, déclenché sur bonne/mauvaise
/// réponse (demande explicite, en complément du son de
/// [lib/services/feedback_sound_service.dart]). Change de [key] à chaque
/// déclenchement (ex. compteur incrémenté) pour rejouer l'animation depuis
/// le début à chaque fois, y compris pour deux flashs de la même couleur
/// coup sur coup.
class AnswerFlashOverlay extends StatelessWidget {
  const AnswerFlashOverlay({super.key, required this.color});

  /// Couleur du flash, ou `null` pour ne rien afficher.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    if (color == null) return const SizedBox.shrink();
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.35, end: 0.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (context, opacity, child) {
          return Container(color: color.withValues(alpha: opacity));
        },
      ),
    );
  }
}
