import 'package:flutter/material.dart';

/// Bouton qui ne déclenche [onConfirmed] qu'après un appui maintenu pendant
/// [duration] (cf. PRD 6.1 : le changement de profil doit être protégé par
/// "une action simple mais non triviale pour un jeune enfant, ex. maintien
/// de 3 secondes", pour éviter les déclenchements accidentels). L'anneau de
/// progression qui se remplit pendant l'appui sert de retour visuel ; un
/// relâchement avant la fin annule sans effet.
class HoldToConfirmButton extends StatefulWidget {
  const HoldToConfirmButton({
    super.key,
    required this.icon,
    required this.onConfirmed,
    this.duration = const Duration(seconds: 3),
  });

  final IconData icon;
  final VoidCallback onConfirmed;
  final Duration duration;

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..addStatusListener(_onStatusChanged);

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onConfirmed();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancelHold() {
    if (_controller.isAnimating) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // onLongPress* plutôt que onTap* : le reconnaisseur de tap annule au
    // moindre mouvement du doigt (quelques pixels), ce qu'un appui réel de
    // 3 secondes déclenche presque toujours (micro-tremblement naturel de
    // la main) — le reconnaisseur d'appui long tolère ce mouvement une
    // fois l'appui reconnu, ce qui le rend fiable pour un maintien aussi
    // long.
    return GestureDetector(
      onLongPressStart: (_) => _controller.forward(),
      onLongPressEnd: (_) => _cancelHold(),
      onLongPressCancel: _cancelHold,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 3,
              ),
            ),
            Icon(widget.icon),
          ],
        ),
      ),
    );
  }
}
