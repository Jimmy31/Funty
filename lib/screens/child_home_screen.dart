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

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileStore>().byId(widget.profileId);
    final catalogStore = context.watch<CatalogStore>();
    final performanceStore = context.watch<PerformanceStore>();

    final activeIds = catalogStore.activeIdsFor(widget.profileId);
    final activeExercises = catalogStore.exercises
        .where((e) => activeIds.contains(e.id))
        .toList();

    return PopScope(
      // Cet écran est atteint via context.go (pas d'historique go_router en
      // dessous) : sans interception, le retour système n'a rien vers quoi
      // revenir et ferme l'application entière. On le redirige donc
      // explicitement vers la sélection de profil, pour un comportement de
      // retour normal (cf. revirement PRD 6.1 : simple tap plutôt qu'un
      // geste protégé, jugé peu intuitif et peu fiable au toucher réel).
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
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
      ),
    );
  }
}
