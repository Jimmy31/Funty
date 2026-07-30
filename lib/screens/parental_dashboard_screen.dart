import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../models/profile.dart';
import '../repositories/question_stats_repository.dart';
import '../screens/exercise_stats_screen.dart';
import '../state/catalog_store.dart';
import '../state/performance_store.dart';
import '../state/profile_store.dart';
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
        title: const Text('Espace parental'),
        actions: [
          // Accès direct au catalogue (cf. PRD 6.6), sans passer par la
          // section d'un profil précis : consultation et réglages des
          // exercices seulement. L'activation, elle, se fait profil par
          // profil (bouton "Curer les exercices" de chaque section).
          IconButton(
            tooltip: 'Catalogue',
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => context.push('/catalog'),
          ),
        ],
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

  Future<void> _edit(BuildContext context) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => CreateProfileDialog(
        initialName: widget.profile.name,
        initialAvatarId: widget.profile.avatarId,
      ),
    );
    if (result == null || !context.mounted) return;
    await context.read<ProfileStore>().updateProfile(
      widget.profile.id,
      name: result.$1,
      avatarId: result.$2,
    );
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
                IconButton(
                  tooltip: 'Curer les exercices',
                  icon: const Icon(Icons.tune),
                  onPressed: () =>
                      context.push('/profiles/${widget.profile.id}/catalog'),
                ),
                IconButton(
                  tooltip: 'Modifier le profil',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _edit(context),
                ),
                IconButton(
                  tooltip: 'Supprimer le profil',
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
              // Une ligne par exercice pratiqué : son nom et sa moyenne de
              // réussite, rien de plus (cf. PRD 6.6). Le détail question par
              // question est à un tap de là.
              for (final performance in performances)
                _ExerciseSummaryRow(
                  profileId: widget.profile.id,
                  exerciseId: performance.exerciseId,
                  exercise: catalogStore.byId(performance.exerciseId),
                ),
          ],
        ),
      ),
    );
  }
}

/// Une ligne du tableau de bord : nom de l'exercice et moyenne de ses
/// pourcentages de réussite par question (cf. PRD 6.6). Mène au détail
/// question par question.
class _ExerciseSummaryRow extends StatelessWidget {
  const _ExerciseSummaryRow({
    required this.profileId,
    required this.exerciseId,
    required this.exercise,
  });

  final String profileId;
  final String exerciseId;
  final Exercise? exercise;

  @override
  Widget build(BuildContext context) {
    final exercise = this.exercise;
    final title = exercise?.title ?? exerciseId;

    // Comptage n'a pas de granularité "question" (cf. PRD 6.2/6.5) : ni
    // moyenne par question, ni tableau de détail à afficher.
    if (exercise == null || exercise.isSequentialException) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        trailing: const Text('—', style: TextStyle(color: Colors.grey)),
      );
    }

    return FutureBuilder<Map<String, QuestionTiming>>(
      future: context.read<QuestionStatsRepository>().recentTimingByQuestion(
        profileId,
        exerciseId,
        bronzeThreshold: exercise.bronzeThreshold,
        sampleSize: questionStatsSampleSize,
      ),
      builder: (context, snapshot) {
        final average = snapshot.hasData
            ? averageTiming(snapshot.data!.values)
            : null;
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: timingBackground(average, exercise),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              average == null ? 'N/A' : formatSeconds(average),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: average == null ? Colors.grey : Colors.black87,
              ),
            ),
          ),
          onTap: () => context.push('/parental/stats/$profileId/$exerciseId'),
        );
      },
    );
  }
}
