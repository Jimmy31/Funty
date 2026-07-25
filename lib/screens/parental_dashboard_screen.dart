import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../models/profile.dart';
import '../repositories/question_stats_repository.dart';
import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../state/profile_store.dart';
import '../widgets/badge_icon.dart';
import '../widgets/create_profile_dialog.dart';
import '../widgets/profile_avatar.dart';

/// Tableau de bord parental (cf. PRD 6.6) : gestion des profils, entrée vers
/// la curation (réutilise l'écran Catalogue), aperçu de performance par
/// exercice et, en dessous, les questions précises qui posent le plus de
/// difficulté à l'enfant (cf. [_QuestionDifficultyHint]).
class ParentalDashboardScreen extends StatelessWidget {
  const ParentalDashboardScreen({super.key});

  Future<void> _createProfile(BuildContext context) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => const CreateProfileDialog(),
    );
    if (result == null || !context.mounted) return;

    final store = context.read<ProfileStore>();
    final profile = await store.createProfile(
      name: result.$1,
      avatarId: result.$2,
    );
    if (!context.mounted) return;
    // Toujours directement le catalogue à la création (cf. PRD 6.3), sans
    // origin=creation ici : depuis le tableau de bord, "Terminé" doit
    // revenir au tableau de bord, pas filer vers la vue enfant.
    context.push('/profiles/${profile.id}/catalog');
  }

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfileStore>().profiles;

    return Scaffold(
      appBar: AppBar(
        // Bouton retour explicite : cet écran est atteint via context.go
        // (le succès du PIN remplace l'historique), donc le geste retour
        // système n'a rien vers quoi revenir et quitterait l'app.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Espace parental'),
      ),
      body: profiles.isEmpty
          ? const Center(child: Text('Aucun profil pour l\'instant.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: profiles.length,
              itemBuilder: (context, index) =>
                  _ProfileSection(profile: profiles[index]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProfile(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau profil'),
      ),
    );
  }
}

class _ProfileSection extends StatefulWidget {
  const _ProfileSection({required this.profile});

  final Profile profile;

  @override
  State<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<_ProfileSection> {
  @override
  void initState() {
    super.initState();
    context.read<PerformanceStore>().ensureLoaded(widget.profile.id);
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le profil "${widget.profile.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ProfileStore>().deleteProfile(widget.profile.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogStore = context.watch<CatalogStore>();
    final performances = context.watch<PerformanceStore>().forProfile(
      widget.profile.id,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(avatarId: widget.profile.avatarId, radius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.profile.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.tune),
                  label: const Text('Curer les exercices'),
                  onPressed: () => context.push(
                    '/profiles/${widget.profile.id}/catalog',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(context),
                ),
              ],
            ),
            const Divider(),
            if (performances.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Aucune performance enregistrée pour l\'instant.'),
              )
            else
              for (final performance in performances)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BadgeIcon(level: performance.badgeLevel, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              catalogStore.byId(performance.exerciseId)?.title ??
                                  performance.exerciseId,
                            ),
                          ),
                          Text('${performance.successRatePercent}%'),
                        ],
                      ),
                      _QuestionDifficultyHint(
                        profileId: widget.profile.id,
                        exercise: catalogStore.byId(performance.exerciseId),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// Questions précises posant le plus de difficulté à l'enfant au sein d'un
/// exercice (cf. PRD 6.6), au-delà du taux de réussite agrégé affiché
/// au-dessus — approximée par le temps de réponse moyen le plus élevé.
class _QuestionDifficultyHint extends StatelessWidget {
  const _QuestionDifficultyHint({
    required this.profileId,
    required this.exercise,
  });

  final String profileId;
  final Exercise? exercise;

  @override
  Widget build(BuildContext context) {
    final exercise = this.exercise;
    // Comptage n'a pas de granularité "question" (cf. PRD 6.2/6.5).
    if (exercise == null || exercise.isSequentialException) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<Map<String, Duration>>(
      future: context
          .read<QuestionStatsRepository>()
          .averageResponseTimeByQuestion(profileId, exercise.id),
      builder: (context, snapshot) {
        final data = snapshot.data;
        // Il faut au moins 2 questions distinctes pratiquées pour qu'un
        // classement de difficulté relative ait un sens.
        if (data == null || data.length < 2) return const SizedBox.shrink();

        final sorted = data.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final hardestLabels = sorted.take(2).map((entry) {
          final matches = exercise.questions.where((q) => q.id == entry.key);
          final question = matches.isEmpty ? null : matches.first;
          return question?.displayValue ?? entry.key;
        }).join(', ');

        return Padding(
          padding: const EdgeInsets.only(left: 30, top: 2),
          child: Text(
            'Points faibles : $hardestLabels',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        );
      },
    );
  }
}
