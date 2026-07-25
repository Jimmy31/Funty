/// Classe scolaire française (PS -> CM2), utilisée comme repère indicatif
/// affiché sur chaque exercice (cf. PRD 6.2) — jamais une restriction
/// technique d'accès.
enum SchoolGrade {
  ps('PS'),
  ms('MS'),
  gs('GS'),
  cp('CP'),
  ce1('CE1'),
  ce2('CE2'),
  cm1('CM1'),
  cm2('CM2');

  const SchoolGrade(this.label);

  final String label;
}
