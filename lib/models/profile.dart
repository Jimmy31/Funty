/// Un profil enfant local sur l'appareil (cf. PRD 6.1). Pas de tranche d'âge
/// attachée au profil lui-même — l'âge n'intervient qu'en métadonnée sur les
/// exercices (cf. [SchoolGrade]).
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.avatarId,
    required this.createdAt,
  });

  final String id;
  final String name;

  /// Référence vers un avatar parmi un petit set fixe local (emoji pour
  /// l'instant, pas encore de vraies illustrations).
  final String avatarId;
  final DateTime createdAt;
}
