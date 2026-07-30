import 'package:flutter/material.dart';

import '../models/exercise.dart';

/// Carte d'exercice réutilisée par le catalogue (avec un [trailing] de type
/// toggle) et la vue enfant (sans trailing, ou avec un badge).
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    this.trailing,
    this.onTap,
    this.showDetails = true,
  });

  final Exercise exercise;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Classe scolaire : utile au parent dans le catalogue (curation), pas à
  /// l'enfant qui ne la comprend pas — cachée dans la vue enfant via
  /// `showDetails: false`.
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(exercise.title),
        subtitle: showDetails ? Text(exercise.schoolGrade.label) : null,
        trailing: trailing,
      ),
    );
  }
}
