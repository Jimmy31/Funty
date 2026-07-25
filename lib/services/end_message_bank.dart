import 'dart:math';

/// Messages de fin d'exercice (cf. PRD 6.7) : au moins 3 variantes par
/// niveau de score (0/bronze/argent/or), jamais négatifs, tirées au hasard
/// pour limiter la répétition mot pour mot. Réutilisée telle quelle par
/// l'exercice Comptage (même principe, score 0-3 basé sur le point atteint
/// plutôt que sur un temps).
const _messagesByLevel = <int, List<String>>{
  0: [
    "Ce n'est pas grave, avec un peu d'entraînement tu vas y arriver !",
    "Aïe aïe aïe, c'était difficile on dirait ! On réessaie bientôt ?",
    "Pas facile celui-là, mais tu progresses à chaque fois que tu essaies !",
  ],
  1: [
    "Bien joué, tu as gagné une grenouille de bronze !",
    "Bravo, continue comme ça, tu es sur la bonne voie !",
    "Super effort, une grenouille bronze pour toi !",
  ],
  2: [
    "Bravo, une grenouille d'argent, tu progresses super bien !",
    "Excellent travail, tu deviens de plus en plus rapide !",
    "Génial, une belle grenouille argentée pour toi !",
  ],
  3: [
    "Bravo, tu as été super rapide sur ce coup-là, tu as gagné une grenouille dorée !",
    "Incroyable, une grenouille en or, tu es un champion !",
    "Fantastique, tu maîtrises vraiment bien, bravo pour cette grenouille dorée !",
  ],
};

final _random = Random();

/// Tire au hasard une variante de message pour le [badgeLevel] donné
/// (0 à 3, cf. PRD 6.7).
String pickEndMessage(int badgeLevel) {
  final messages = _messagesByLevel[badgeLevel] ?? _messagesByLevel[0]!;
  return messages[_random.nextInt(messages.length)];
}
