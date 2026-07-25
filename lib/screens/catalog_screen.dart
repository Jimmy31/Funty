import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/school_grade.dart';
import '../models/subject.dart';
import '../state/catalog_store.dart';
import '../widgets/exercise_card.dart';
import '../widgets/subject_theme_group.dart';

/// Catalogue d'exercices (cf. PRD 6.2/6.3), réutilisé à la fois juste après
/// la création d'un profil et depuis l'espace parental pour la curation
/// continue. Activer et désactiver un exercice sont le même geste (toggle),
/// symétrie exigée par le PRD.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.profileId});

  final String profileId;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  Subject? _subjectFilter;
  SchoolGrade? _gradeFilter;

  @override
  void initState() {
    super.initState();
    context.read<CatalogStore>().ensureActivationLoaded(widget.profileId);
  }

  /// Après "Terminé" : un profil tout juste créé va directement à sa vue
  /// enfant (rien d'utile à faire sur l'écran d'origine), sinon retour
  /// standard à l'écran qui a poussé le catalogue (espace parental).
  void _onDone(BuildContext context) {
    final origin = GoRouterState.of(context).uri.queryParameters['origin'];
    if (origin == 'creation') {
      context.go('/profiles/${widget.profileId}/home');
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CatalogStore>();
    final exercises = store.exercises.where((exercise) {
      if (_subjectFilter != null && exercise.subject != _subjectFilter) {
        return false;
      }
      if (_gradeFilter != null && exercise.schoolGrade != _gradeFilter) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        actions: [
          TextButton(
            onPressed: () => _onDone(context),
            child: const Text(
              'Terminé',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            subjectFilter: _subjectFilter,
            gradeFilter: _gradeFilter,
            onSubjectChanged: (s) => setState(() => _subjectFilter = s),
            onGradeChanged: (g) => setState(() => _gradeFilter = g),
          ),
          Expanded(
            child: SubjectThemeGroup(
              exercises: exercises,
              emptyMessage: 'Aucun exercice pour ces filtres.',
              itemBuilder: (context, exercise) => ExerciseCard(
                exercise: exercise,
                // Le Switch est l'unique geste d'activation/désactivation
                // (cf. PRD 6.3, ajout et retrait symétriques) : pas de onTap
                // sur la carte en plus, qui se déclencherait en double avec
                // le Switch et annulerait visuellement le changement.
                trailing: Switch(
                  value: store.isActive(widget.profileId, exercise.id),
                  onChanged: (_) => store.toggleActive(
                    widget.profileId,
                    exercise.id,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.subjectFilter,
    required this.gradeFilter,
    required this.onSubjectChanged,
    required this.onGradeChanged,
  });

  final Subject? subjectFilter;
  final SchoolGrade? gradeFilter;
  final ValueChanged<Subject?> onSubjectChanged;
  final ValueChanged<SchoolGrade?> onGradeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('Toutes matières'),
              selected: subjectFilter == null,
              onSelected: (_) => onSubjectChanged(null),
            ),
            const SizedBox(width: 8),
            for (final subject in Subject.values) ...[
              FilterChip(
                label: Text(subject.label),
                selected: subjectFilter == subject,
                onSelected: (selected) =>
                    onSubjectChanged(selected ? subject : null),
              ),
              const SizedBox(width: 8),
            ],
            const SizedBox(width: 16),
            FilterChip(
              label: const Text('Toutes classes'),
              selected: gradeFilter == null,
              onSelected: (_) => onGradeChanged(null),
            ),
            const SizedBox(width: 8),
            for (final grade in SchoolGrade.values) ...[
              FilterChip(
                label: Text(grade.label),
                selected: gradeFilter == grade,
                onSelected: (selected) =>
                    onGradeChanged(selected ? grade : null),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}
