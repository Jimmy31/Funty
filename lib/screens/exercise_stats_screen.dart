import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../repositories/question_stats_repository.dart';
import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../state/profile_store.dart';

/// Nombre de tentatives retenues par question (cf. PRD 6.6).
const questionStatsSampleSize = 5;

/// Détail des statistiques d'un exercice pour un profil (cf. PRD 6.6) :
/// toutes les questions possibles de l'exercice, avec leur temps de réponse
/// moyen sur les dernières tentatives, plus la remise à zéro.
class ExerciseStatsScreen extends StatefulWidget {
  const ExerciseStatsScreen({
    super.key,
    required this.profileId,
    required this.exerciseId,
  });

  final String profileId;
  final String exerciseId;

  @override
  State<ExerciseStatsScreen> createState() => _ExerciseStatsScreenState();
}

class _ExerciseStatsScreenState extends State<ExerciseStatsScreen> {
  late Future<Map<String, QuestionTiming>> _stats;

  @override
  void initState() {
    super.initState();
    _stats = _load();
  }

  Future<Map<String, QuestionTiming>> _load() {
    final exercise = context.read<CatalogStore>().byId(widget.exerciseId);
    return context.read<QuestionStatsRepository>().recentTimingByQuestion(
      widget.profileId,
      widget.exerciseId,
      bronzeThreshold: exercise?.bronzeThreshold ?? const Duration(seconds: 7),
      sampleSize: questionStatsSampleSize,
    );
  }

  Future<void> _reset(Exercise exercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remettre les statistiques à zéro ?'),
        content: Text(
          'Tout l\'historique de cet enfant sur "${exercise.title}" sera '
          'effacé : temps par question, badge et nombre de tentatives. '
          'Cette action est définitive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remettre à zéro'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await context.read<QuestionStatsRepository>().resetExercise(
      widget.profileId,
      widget.exerciseId,
    );
    if (!mounted) return;
    await context.read<PerformanceStore>().reset(
      widget.profileId,
      widget.exerciseId,
    );
    if (!mounted) return;
    setState(() => _stats = _load());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statistiques remises à zéro.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = context.watch<CatalogStore>().byId(widget.exerciseId);
    final profile = context
        .watch<ProfileStore>()
        .profiles
        .where((p) => p.id == widget.profileId)
        .firstOrNull;

    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistiques')),
        body: const Center(child: Text('Exercice introuvable.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
        actions: [
          IconButton(
            tooltip: 'Remettre à zéro',
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _reset(exercise),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, QuestionTiming>>(
        future: _stats,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data ?? const <String, QuestionTiming>{};
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (profile != null)
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 4),
              Text(
                'Temps de réponse moyen sur les $questionStatsSampleSize '
                'dernières tentatives, la plus lente en premier. Une mauvaise '
                'réponse compte pour '
                '${formatSeconds(failedAttemptTime(exercise.bronzeThreshold))}. '
                'Les questions jamais posées sont en "N/A" et ne comptent pas '
                'dans la moyenne.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              _ThresholdLegend(exercise: exercise),
              const SizedBox(height: 16),
              _TimingTable(exercise: exercise, stats: stats),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _reset(exercise),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Remettre les statistiques à zéro'),
              ),
            ],
          );
        },
      ),
    );
  }
}

String formatSeconds(Duration duration) {
  final seconds = duration.inMilliseconds / 1000;
  final text = seconds == seconds.roundToDouble()
      ? seconds.round().toString()
      : seconds.toStringAsFixed(1);
  return '$text s';
}

/// Moyenne des temps des questions déjà posées (cf. PRD 6.6) — les "N/A"
/// sont écartées plutôt que comptées, sans quoi un exercice à peine entamé
/// afficherait un temps faussé.
Duration? averageTiming(Iterable<QuestionTiming> stats) {
  final values = stats
      .where((s) => s.hasData)
      .map((s) => s.average!.inMilliseconds)
      .toList();
  if (values.isEmpty) return null;
  return Duration(
    milliseconds: values.reduce((a, b) => a + b) ~/ values.length,
  );
}

/// Couleur de fond d'une cellule selon les seuils de médaille de l'exercice
/// (cf. PRD 6.7). Trois couleurs pour quatre paliers : or et argent sont
/// regroupés en vert (l'enfant décroche une médaille "haute"), bronze en
/// jaune, et l'absence de médaille en rouge.
Color? timingBackground(Duration? average, Exercise exercise) {
  if (average == null) return null;
  if (average <= exercise.silverThreshold) return const Color(0xFFC8E6C9);
  if (average <= exercise.bronzeThreshold) return const Color(0xFFFFF9C4);
  return const Color(0xFFFFCDD2);
}

class _ThresholdLegend extends StatelessWidget {
  const _ThresholdLegend({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        _chip(
          const Color(0xFFC8E6C9),
          '≤ ${formatSeconds(exercise.silverThreshold)} (or/argent)',
        ),
        _chip(
          const Color(0xFFFFF9C4),
          '≤ ${formatSeconds(exercise.bronzeThreshold)} (bronze)',
        ),
        _chip(
          const Color(0xFFFFCDD2),
          '> ${formatSeconds(exercise.bronzeThreshold)}',
        ),
      ],
    );
  }

  Widget _chip(Color color, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}

class _TimingTable extends StatelessWidget {
  const _TimingTable({required this.exercise, required this.stats});

  final Exercise exercise;
  final Map<String, QuestionTiming> stats;

  @override
  Widget build(BuildContext context) {
    if (exercise.questions.isEmpty) {
      return const Text('Cet exercice n\'a pas de questions individuelles.');
    }

    // La plus lente en premier : le parent voit d'emblée où ça coince. Les
    // questions jamais posées ferment la marche, elles n'ont pas de temps à
    // comparer.
    final rows = exercise.questions.toList()
      ..sort((a, b) {
        final ta = stats[a.id]?.average;
        final tb = stats[b.id]?.average;
        if (ta == null && tb == null) return 0;
        if (ta == null) return 1;
        if (tb == null) return -1;
        return tb.compareTo(ta);
      });

    final headerStyle = Theme.of(
      context,
    ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold);

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            _cell(Text('Question', style: headerStyle)),
            _cell(
              Text(
                'Temps moyen',
                style: headerStyle,
                textAlign: TextAlign.right,
              ),
            ),
            _cell(
              Text(
                'Tentatives',
                style: headerStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        for (final question in rows)
          _row(question.displayValue, stats[question.id]),
      ],
    );
  }

  TableRow _row(String label, QuestionTiming? timing) {
    final average = timing?.average;
    return TableRow(
      children: [
        _cell(Text(label)),
        // Le fond coloré doit remplir toute la cellule : la couleur porte
        // donc sur le conteneur qui applique lui-même la marge intérieure,
        // et non sur un enfant entouré de blanc.
        _cell(
          Text(
            average == null ? 'N/A' : formatSeconds(average),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: average == null ? Colors.grey : Colors.black87,
              fontWeight: average == null ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          background: timingBackground(average, exercise),
        ),
        _cell(
          Text(
            '${timing?.attempts ?? 0}',
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  static Widget _cell(Widget child, {Color? background}) => Container(
    color: background,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    child: child,
  );
}
