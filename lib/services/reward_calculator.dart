import '../models/exercise.dart';

/// Calcule le niveau de badge (0-3) obtenu à la fin d'une série. Interface
/// pour pouvoir isoler l'écran d'exercice du détail du calcul.
abstract class RewardCalculator {
  int calculateBadgeLevel({
    required Exercise exercise,
    required List<Duration> responseTimes,
  });
}

/// Implémentation réelle (cf. PRD 6.7) : le temps moyen par question sur la
/// série (temps jusqu'à la bonne réponse, pénalités de 5s incluses, cf.
/// PRD 6.5) comparé aux seuils bronze/argent/or propres à l'exercice.
class AverageTimeRewardCalculator implements RewardCalculator {
  const AverageTimeRewardCalculator();

  @override
  int calculateBadgeLevel({
    required Exercise exercise,
    required List<Duration> responseTimes,
  }) {
    if (responseTimes.isEmpty) return 0;
    final totalMs = responseTimes.fold<int>(
      0,
      (sum, time) => sum + time.inMilliseconds,
    );
    final averageMs = totalMs / responseTimes.length;
    if (averageMs <= exercise.goldThreshold.inMilliseconds) return 3;
    if (averageMs <= exercise.silverThreshold.inMilliseconds) return 2;
    if (averageMs <= exercise.bronzeThreshold.inMilliseconds) return 1;
    return 0;
  }
}
