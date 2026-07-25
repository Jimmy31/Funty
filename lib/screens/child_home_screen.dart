import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../state/profile_store.dart';
import '../widgets/badge_icon.dart';
import '../widgets/exercise_card.dart';
import '../widgets/hold_to_confirm_button.dart';
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
      // dessous), donc laisser le geste retour système agir par défaut
      // ferme carrément l'application plutôt que de ne rien faire — un vrai
      // bug, en plus de contourner la protection voulue par le PRD 6.1
      // (seul le maintien de 3 secondes doit permettre de quitter ce profil).
      // canPop: false absorbe le retour système sans effet, exactement
      // comme un simple tap sur le bouton de maintien.
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          // Maintien de 3 secondes plutôt qu'un simple tap (cf. PRD 6.1) :
          // le changement de profil doit être protégé par un geste non
          // trivial pour un jeune enfant, pour éviter les sorties accidentelles.
          leading: HoldToConfirmButton(
            icon: Icons.arrow_back,
            onConfirmed: () => context.go('/'),
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
