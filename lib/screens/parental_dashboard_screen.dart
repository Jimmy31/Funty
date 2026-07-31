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
    // Sans ça, la liste des exercices activés du profil serait vide jusqu'à
    // ce qu'un autre écran ait chargé son activation.
    context.read<CatalogStore>().ensureActivationLoaded(widget.profile.id);
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
    final performanceStore = context.watch<PerformanceStore>();

    // Les exercices activés pour ce profil, dans l'ordre du catalogue — et
    // non ceux déjà pratiqués. Lister les seconds donnait un résumé sans
    // rapport avec la curation : un exercice tout juste activé n'y figurait
    // pas, un exercice retiré y restait.
    final actifs = catalogStore.activeIdsFor(widget.profile.id);
    final exercices = catalogStore.exercises
        .where((exercise) => actifs.contains(exercise.id))
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Prénom et avatar s'éditent par appui long sur eux-mêmes,
                // dans le dialogue qui porte déjà les deux — plutôt qu'un
                // bouton crayon séparé, qui n'indiquait pas non plus ce
                // qu'il modifiait.
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onLongPress: () => _edit(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          ProfileAvatar(
                            avatarId: widget.profile.avatarId,
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.profile.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Curer les exercices',
                  icon: const Icon(Icons.tune),
                  onPressed: () =>
                      context.push('/profiles/${widget.profile.id}/catalog'),
                ),
                IconButton(
                  tooltip: 'Supprimer le profil',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(context),
                ),
              ],
            ),
            const Divider(),
            if (exercices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Aucun exercice activé pour l\'instant.\n'
                  'Choisissez-en avec le bouton de curation ci-dessus.',
                ),
              )
            else
              // Une ligne par exercice activé : son nom et son temps de
              // réponse moyen, rien de plus (cf. PRD 6.6). Le détail question
              // par question est à un tap de là.
              for (final exercise in exercices)
                _ExerciseSummaryRow(
                  profileId: widget.profile.id,
                  exerciseId: exercise.id,
                  exercise: exercise,
                  revision: performanceStore.revision,
                ),
          ],
        ),
      ),
    );
  }
}

/// Une ligne du tableau de bord : nom de l'exercice et son temps de réponse
/// moyen (cf. PRD 6.6). Mène au détail question par question.
///
/// Avec état, et non un simple [FutureBuilder] construit à la volée : la
/// requête doit être lancée une fois, pas à chaque reconstruction de l'écran.
/// Relancée à chaque build, elle repassait par son état d'attente — affiché
/// comme "N/A", faute de distinguer "pas encore chargé" de "jamais posée" —
/// et une ligne pourtant renseignée pouvait rester bloquée dessus.
class _ExerciseSummaryRow extends StatefulWidget {
  const _ExerciseSummaryRow({
    required this.profileId,
    required this.exerciseId,
    required this.exercise,
    required this.revision,
  });

  final String profileId;
  final String exerciseId;
  final Exercise? exercise;

  /// Révision de [PerformanceStore] : son changement est le signal qu'une
  /// écriture a eu lieu (typiquement une remise à zéro) et que le temps
  /// affiché doit être relu.
  final int revision;

  @override
  State<_ExerciseSummaryRow> createState() => _ExerciseSummaryRowState();
}

class _ExerciseSummaryRowState extends State<_ExerciseSummaryRow> {
  Future<Map<String, QuestionTiming>>? _timings;

  @override
  void initState() {
    super.initState();
    _timings = _load();
  }

  @override
  void didUpdateWidget(_ExerciseSummaryRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision ||
        oldWidget.exerciseId != widget.exerciseId ||
        oldWidget.profileId != widget.profileId) {
      setState(() => _timings = _load());
    }
  }

  Future<Map<String, QuestionTiming>>? _load() {
    final exercise = widget.exercise;
    if (exercise == null || exercise.isSequentialException) return null;
    return context.read<QuestionStatsRepository>().recentTimingByQuestion(
      widget.profileId,
      widget.exerciseId,
      bronzeThreshold: exercise.bronzeThreshold,
      sampleSize: questionStatsSampleSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final title = exercise?.title ?? widget.exerciseId;

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
      future: _timings,
      builder: (context, snapshot) {
        final charge = snapshot.connectionState == ConnectionState.done;
        final average = charge ? averageTiming(snapshot.data!.values) : null;
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
            // Tant que la lecture n'est pas finie, un tiret plutôt que "N/A" :
            // "N/A" affirme que l'enfant n'a jamais répondu, ce qu'on ne sait
            // pas encore.
            child: Text(
              !charge
                  ? '…'
                  : (average == null ? 'N/A' : formatSeconds(average)),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: average == null ? Colors.grey : Colors.black87,
              ),
            ),
          ),
          onTap: () => context.push(
            '/parental/stats/${widget.profileId}/${widget.exerciseId}',
          ),
        );
      },
    );
  }
}
