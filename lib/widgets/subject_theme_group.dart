import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/subject.dart';

/// Regroupement Matière -> Thème -> Exercice, partagé entre le Catalogue et
/// la Vue enfant (cf. PRD 6.2/6.3) ; seul ce qui est fait de chaque exercice
/// (toggle, ou simple tap) diffère entre les deux écrans, via [itemBuilder].
class SubjectThemeGroup extends StatelessWidget {
  const SubjectThemeGroup({
    super.key,
    required this.exercises,
    required this.itemBuilder,
    this.emptyMessage = 'Aucun exercice.',
  });

  final List<Exercise> exercises;
  final Widget Function(BuildContext context, Exercise exercise) itemBuilder;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    final bySubject = <Subject, Map<String, List<Exercise>>>{};
    for (final exercise in exercises) {
      final themes = bySubject.putIfAbsent(exercise.subject, () => {});
      themes.putIfAbsent(exercise.theme, () => []).add(exercise);
    }

    return ListView(
      children: [
        for (final subjectEntry in bySubject.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              subjectEntry.key.label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final themeEntry in subjectEntry.value.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                themeEntry.key,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final exercise in themeEntry.value)
              itemBuilder(context, exercise),
          ],
        ],
      ],
    );
  }
}
