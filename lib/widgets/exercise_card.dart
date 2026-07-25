import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/response_mode.dart';

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

  /// Icône de mode de réponse et classe scolaire : utiles au parent dans le
  /// catalogue (curation), pas à l'enfant qui ne les comprend pas — cachées
  /// dans la vue enfant via `showDetails: false`.
  final bool showDetails;

  IconData get _responseModeIcon => switch (exercise.responseMode) {
    ResponseMode.vocal => Icons.mic,
    ResponseMode.tactile => Icons.touch_app,
    ResponseMode.vocalEtTactile => Icons.record_voice_over,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: showDetails ? Icon(_responseModeIcon) : null,
        title: Text(exercise.title),
        subtitle: showDetails ? Text(exercise.schoolGrade.label) : null,
        trailing: trailing,
      ),
    );
  }
}
