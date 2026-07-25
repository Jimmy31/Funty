/// Performance d'un profil sur un exercice donné. Pour ce passage "squelette",
/// les valeurs sont factices (générées ou modifiées de façon simplifiée à la
/// fin d'un exercice) — le vrai calcul de badge (PRD 6.7) et le suivi par
/// question (PRD 6.4/6.5) viendront dans une passe séparée.
class ExercisePerformanceStub {
  const ExercisePerformanceStub({
    required this.profileId,
    required this.exerciseId,
    required this.badgeLevel,
    required this.successRatePercent,
    required this.attemptsCount,
    this.lastPracticedAt,
  });

  final String profileId;
  final String exerciseId;

  /// 0 = aucun badge, 1 = bronze, 2 = argent, 3 = or (cf. PRD 6.7).
  final int badgeLevel;

  final int successRatePercent;
  final int attemptsCount;
  final DateTime? lastPracticedAt;

  ExercisePerformanceStub copyWith({
    int? badgeLevel,
    int? successRatePercent,
    int? attemptsCount,
    DateTime? lastPracticedAt,
  }) {
    return ExercisePerformanceStub(
      profileId: profileId,
      exerciseId: exerciseId,
      badgeLevel: badgeLevel ?? this.badgeLevel,
      successRatePercent: successRatePercent ?? this.successRatePercent,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
    );
  }
}
