import 'package:audioplayers/audioplayers.dart';

/// Retour sonore immédiat bonne/mauvaise réponse (demande explicite, en
/// complément du flash visuel de [lib/widgets/answer_flash_overlay.dart]).
/// Deux lecteurs distincts pour ne pas se couper l'un l'autre en cas de
/// déclenchements rapprochés.
///
/// Les niveaux sont réglés dans les fichiers eux-mêmes, pas ici : le volume
/// d'un [AudioPlayer] plafonne à 1.0, qui est déjà la valeur par défaut, donc
/// monter le son d'erreur passe forcément par l'amplification de l'asset
/// (`incorrect.wav` est normalisé plus fort que `correct.wav`, à la demande).
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
