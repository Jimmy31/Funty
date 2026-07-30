import 'package:audioplayers/audioplayers.dart';

/// Retour sonore immédiat bonne/mauvaise réponse (demande explicite, en
/// complément du flash visuel de [lib/widgets/answer_flash_overlay.dart]).
/// Deux lecteurs distincts pour ne pas se couper l'un l'autre en cas de
/// déclenchements rapprochés.
///
/// Le son d'erreur doit s'entendre plus fort que celui de réussite (demande
/// explicite). Le rapport est entièrement porté par les assets : les deux
/// lecteurs jouent à plein volume, et `incorrect.wav` est plus fort à la fois
/// en niveau (pleine échelle) et en hauteur — 880 → 622 Hz, là où l'oreille
/// et le haut-parleur d'un téléphone sont sensibles, contre 1200 Hz à
/// mi-échelle pour la réussite.
class FeedbackSoundService {
  final _correctPlayer = AudioPlayer();
  final _incorrectPlayer = AudioPlayer();

  Future<void> playCorrect() =>
      _correctPlayer.play(AssetSource('sounds/correct.wav'));

  Future<void> playIncorrect() =>
      _incorrectPlayer.play(AssetSource('sounds/incorrect.wav'));

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _incorrectPlayer.dispose();
  }
}
