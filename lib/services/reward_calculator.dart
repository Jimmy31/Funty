import 'dart:math';

import '../models/exercise.dart';

/// Calcule le niveau de badge (0-3) obtenu à la fin d'une série. Interface
/// pour pouvoir brancher plus tard le vrai calcul (PRD 6.7 : temps moyen par
/// question sur la série comparé aux seuils bronze/argent/or propres à
/// l'exercice) sans toucher à l'écran d'exercice.
abstract class RewardCalculator {
  int calculateBadgeLevel({
    required Exercise exercise,
    required List<Duration> responseTimes,
  });
}

/// Implémentation factice pour ce passage "squelette" : niveau
/// pseudo-aléatoire, juste pour que le tableau de bord parental ait des
/// données qui évoluent après avoir joué un exercice.
///
/// TODO(recompenses): remplacer par le vrai calcul PRD 6.7 : moyenne des
/// [responseTimes] comparée à exercise.bronzeThreshold / silverThreshold /
/// goldThreshold.
class StubRewardCalculator implements RewardCalculator {
  final _random = Random();

  @override
  int calculateBadgeLevel({
    required Exercise exercise,
    required List<Duration> responseTimes,
  }) {
    return _random.nextInt(4);
  }
}
