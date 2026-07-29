import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
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

  Future<void> _openSettings(BuildContext context, Exercise exercise) async {
    final result = await showDialog<_ExerciseSettingsResult>(
      context: context,
      builder: (context) => _ExerciseSettingsDialog(exercise: exercise),
    );
    if (result == null || !context.mounted) return;
    await context.read<CatalogStore>().updateExerciseSettings(
      exercise.id,
      questionsPerSeries: result.questionsPerSeries,
      bronzeThreshold: Duration(seconds: result.bronzeSeconds),
      silverThreshold: Duration(seconds: result.silverSeconds),
      goldThreshold: Duration(seconds: result.goldSeconds),
    );
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
            child: const Text('Terminé', style: TextStyle(color: Colors.white)),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Comptage n'a ni série ni palier de temps (cf. PRD
                    // 6.2/6.7) : pas de réglage à proposer pour lui.
                    if (!exercise.isSequentialException)
                      IconButton(
                        tooltip: 'Réglages',
                        icon: const Icon(Icons.tune),
                        onPressed: () => _openSettings(context, exercise),
                      ),
                    Switch(
                      value: store.isActive(widget.profileId, exercise.id),
                      onChanged: (_) =>
                          store.toggleActive(widget.profileId, exercise.id),
                    ),
                  ],
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

class _ExerciseSettingsResult {
  const _ExerciseSettingsResult({
    required this.questionsPerSeries,
    required this.bronzeSeconds,
    required this.silverSeconds,
    required this.goldSeconds,
  });

  final int questionsPerSeries;
  final int bronzeSeconds;
  final int silverSeconds;
  final int goldSeconds;
}

/// Réglages parentaux d'un exercice (cf. PRD 6.6/6.7) : nombre de questions
/// par série (slider) et seuils bronze/argent/or, communs à tous les
/// profils de l'appareil pratiquant cet exercice.
class _ExerciseSettingsDialog extends StatefulWidget {
  const _ExerciseSettingsDialog({required this.exercise});

  final Exercise exercise;

  @override
  State<_ExerciseSettingsDialog> createState() =>
      _ExerciseSettingsDialogState();
}

class _ExerciseSettingsDialogState extends State<_ExerciseSettingsDialog> {
  late int _questionsPerSeries = widget.exercise.questionsPerSeries;
  late int _bronzeSeconds = widget.exercise.bronzeThreshold.inSeconds;
  late int _silverSeconds = widget.exercise.silverThreshold.inSeconds;
  late int _goldSeconds = widget.exercise.goldThreshold.inSeconds;

  /// Un palier n'a de sens que si or <= argent <= bronze (exigences
  /// croissantes, cf. PRD 6.7).
  bool get _isValid =>
      _goldSeconds <= _silverSeconds && _silverSeconds <= _bronzeSeconds;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Réglages — ${widget.exercise.title}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Questions par série : $_questionsPerSeries'),
            Slider(
              value: _questionsPerSeries.toDouble(),
              min: 5,
              max: 20,
              divisions: 15,
              label: '$_questionsPerSeries',
              onChanged: (value) =>
                  setState(() => _questionsPerSeries = value.round()),
            ),
            const SizedBox(height: 8),
            Text('Seuil bronze : $_bronzeSeconds s'),
            Slider(
              value: _bronzeSeconds.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: '$_bronzeSeconds s',
              onChanged: (value) =>
                  setState(() => _bronzeSeconds = value.round()),
            ),
            Text('Seuil argent : $_silverSeconds s'),
            Slider(
              value: _silverSeconds.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: '$_silverSeconds s',
              onChanged: (value) =>
                  setState(() => _silverSeconds = value.round()),
            ),
            Text('Seuil or : $_goldSeconds s'),
            Slider(
              value: _goldSeconds.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: '$_goldSeconds s',
              onChanged: (value) =>
                  setState(() => _goldSeconds = value.round()),
            ),
            if (!_isValid)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Le seuil or doit être ≤ argent ≤ bronze (temps de\nréponse moyen par question, cf. PRD 6.7).',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: !_isValid
              ? null
              : () => Navigator.of(context).pop(
                  _ExerciseSettingsResult(
                    questionsPerSeries: _questionsPerSeries,
                    bronzeSeconds: _bronzeSeconds,
                    silverSeconds: _silverSeconds,
                    goldSeconds: _goldSeconds,
                  ),
                ),
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
