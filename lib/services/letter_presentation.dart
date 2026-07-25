import 'dart:math';

/// Pool de polices pour les variantes "présentation aléatoire" de
/// l'Alphabet (cf. PRD 5.1/8.1) — Roboto (police par défaut Flutter), Noto
/// Sans et Comic Neue (équivalents libres de Verdana/Comic Sans MS actés
/// dans le PRD, cf. pubspec.yaml).
const presentationFonts = ['Roboto', 'Noto Sans', 'Comic Neue'];

/// Lettres à risque de confusion par rotation (cf. PRD 5.1/10) : leur
/// rotation reste plafonnée à 45°, contre une rotation libre pour les
/// autres.
const _confusableLetters = {'b', 'd', 'p', 'q', 'm', 'w'};

/// Rotation maximale (en degrés) pour les lettres sans risque de
/// confusion — le PRD dit seulement "rotation libre", sans borne chiffrée ;
/// 90° garde la lettre lisible sans jamais l'afficher tête en bas.
const _freeRotationMaxDegrees = 90.0;
const _confusableRotationMaxDegrees = 45.0;

class LetterPresentation {
  const LetterPresentation({required this.fontFamily, required this.rotation});

  final String fontFamily;

  /// Angle de rotation en radians, prêt pour [Transform.rotate].
  final double rotation;
}

/// Tire une police et une rotation aléatoires pour afficher [letter] (cf.
/// PRD 5.1 : orientation/police/taille aléatoires pour les variantes
/// "aléatoires" de l'Alphabet).
LetterPresentation randomLetterPresentation(String letter, Random random) {
  final fontFamily = presentationFonts[random.nextInt(presentationFonts.length)];
  final maxDegrees = _confusableLetters.contains(letter.toLowerCase())
      ? _confusableRotationMaxDegrees
      : _freeRotationMaxDegrees;
  final degrees = (random.nextDouble() * 2 - 1) * maxDegrees;
  return LetterPresentation(fontFamily: fontFamily, rotation: degrees * pi / 180);
}
