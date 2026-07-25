import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../state/profile_store.dart';
import '../widgets/badge_icon.dart';
import '../widgets/exercise_card.dart';
import '../widgets/subject_theme_group.dart';

/// Vue enfant (cf. PRD 6.3) : uniquement les exercices activés par le
/// parent pour ce profil, groupés Matière -> Thème.
class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key, required this.profileId});

  final String profileId;

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogStore>().ensureActivationLoaded(widget.profileId);
    context.read<PerformanceStore>().ensureLoaded(widget.profileId);
  }

  Future<void> _confirmLeave(BuildContext context) async {
    // TODO(gestion-profil): remplacer par le geste "maintien 3 secondes" ou
    // petit calcul exigé par le PRD 6.1 pour éviter un changement accidentel
    // de profil ; une simple confirmation suffit pour ce squelette.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer de profil ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Changer'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileStore>().byId(widget.profileId);
    final catalogStore = context.watch<CatalogStore>();
    final performanceStore = context.watch<PerformanceStore>();

    final activeIds = catalogStore.activeIdsFor(widget.profileId);
    final activeExercises = catalogStore.exercises
        .where((e) => activeIds.contains(e.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _confirmLeave(context),
        ),
        title: Text(profile?.name ?? 'Profil'),
      ),
      body: SubjectThemeGroup(
        exercises: activeExercises,
        emptyMessage:
            'Aucun exercice activé pour l\'instant.\nDemande à un parent d\'en ajouter depuis l\'espace parental.',
        itemBuilder: (context, exercise) {
          final matches = performanceStore
              .forProfile(widget.profileId)
              .where((p) => p.exerciseId == exercise.id);
          final performance = matches.isEmpty ? null : matches.first;
          return ExerciseCard(
            exercise: exercise,
            trailing: BadgeIcon(level: performance?.badgeLevel ?? 0),
            onTap: () => context.push(
              '/profiles/${widget.profileId}/exercise/${exercise.id}',
            ),
          );
        },
      ),
    );
  }
}
