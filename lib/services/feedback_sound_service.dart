import 'package:audioplayers/audioplayers.dart';

/// Retour sonore immédiat bonne/mauvaise réponse (demande explicite, en
/// complément du flash visuel de [lib/widgets/answer_flash_overlay.dart]).
/// Deux lecteurs distincts pour ne pas se couper l'un l'autre en cas de
/// déclenchements rapprochés.
///
/// Le son d'erreur doit s'entendre plus fort que celui de réussite (demande
/// explicite). `incorrect.wav` est donc déjà à pleine échelle numérique — on
/// ne peut pas monter plus haut, ni par le volume du lecteur (plafonné à 1.0,
/// sa valeur par défaut), ni par l'asset. Le seul levier restant est de
/// descendre le son de réussite, d'où le [_correctVolume] ci-dessous.
class FeedbackSoundService {
  final _correctPlayer = AudioPlayer();
  final _incorrectPlayer = AudioPlayer();

  static const _correctVolume = 0.6;

  Future<void> playCorrect() => _correctPlayer.play(
    AssetSource('sounds/correct.wav'),
    volume: _correctVolume,
  );

  Future<void> playIncorrect() =>
      _incorrectPlayer.play(AssetSource('sounds/incorrect.wav'));

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _incorrectPlayer.dispose();
  }
}
