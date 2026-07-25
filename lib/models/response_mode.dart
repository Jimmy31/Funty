/// Mode de réponse d'un exercice : attribut propre à chaque exercice,
/// indépendant de la matière ou du thème (cf. PRD 6.2).
enum ResponseMode {
  vocal,
  tactile,
  vocalEtTactile;

  bool get acceptsVocal => this == vocal || this == vocalEtTactile;

  bool get acceptsTactile => this == tactile || this == vocalEtTactile;
}
