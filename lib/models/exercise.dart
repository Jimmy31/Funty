import 'interaction_format.dart';
import 'question.dart';
import 'response_mode.dart';
import 'school_grade.dart';
import 'subject.dart';

/// Un exercice du catalogue (cf. PRD 6.2). Le thème reste une chaîne libre
/// (pas un enum) car la bibliothèque de thèmes a vocation à grandir en
/// continu, sans changement de code (cf. PRD 8.1).
class Exercise {
  const Exercise({
    required this.id,
    required this.subject,
    required this.theme,
    required this.title,
    required this.oralInstruction,
    required this.schoolGrade,
    required this.responseMode,
    this.interactionFormat = InteractionFormat.none,
    this.questionsPerSeries = 10,
    this.bronzeThreshold = const Duration(seconds: 7),
    this.silverThreshold = const Duration(seconds: 4),
    this.goldThreshold = const Duration(seconds: 2),
    this.isSequentialException = false,
    this.questions = const [],
  });

  final String id;
  final Subject subject;
  final String theme;
  final String title;

  /// Consigne donnée à l'oral avant l'exercice (cf. PRD 6.2, consigne orale
  /// systématique) — texte pour l'instant, l'enregistrement audio réel viendra
  /// plus tard.
  final String oralInstruction;

  final SchoolGrade schoolGrade;
  final ResponseMode responseMode;
  final InteractionFormat interactionFormat;

  /// Nombre de questions par série, réglable par le parent (défaut 10,
  /// cf. PRD 6.7).
  final int questionsPerSeries;

  /// Seuils de temps moyen par question pour les paliers de récompense
  /// (cf. PRD 6.7). Défauts : bronze <= 7s, argent <= 4s, or <= 2s.
  final Duration bronzeThreshold;
  final Duration silverThreshold;
  final Duration goldThreshold;

  /// Vrai uniquement pour l'exercice Comptage : pas de questions aléatoires,
  /// donc ni sélection adaptative, ni séries/paliers de récompense, ni règle
  /// des 2 échecs ne s'appliquent (cf. PRD 6.2 et 5.1).
  final bool isSequentialException;

  final List<Question> questions;
}
