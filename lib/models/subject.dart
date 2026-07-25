/// Matière. Le MVP se limite à ces deux matières (cf. PRD 5) ; contrairement
/// au thème (chaîne libre, cf. [exercise.dart]), la matière est un ensemble
/// fermé pour le MVP, un enum convient donc ici.
enum Subject {
  mathematiques('Mathématiques'),
  lectureLangage('Lecture/Langage');

  const Subject(this.label);

  final String label;
}
