import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/exercise.dart';
import '../models/profile.dart';
import '../repositories/question_stats_repository.dart';
import '../state/app_settings_store.dart';
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

  Future<void> _changePin(BuildContext context) async {
    final store = context.read<AppSettingsStore>();
    final currentPin = store.pin;
    if (currentPin == null) return;
    final newPin = await showDialog<String>(
      context: context,
      builder: (context) => _ChangePinDialog(currentPin: currentPin),
    );
    if (newPin == null || !context.mounted) return;
    await store.updatePin(newPin);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code parental mis à jour.')));
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
        actions: [
          // Accès direct au catalogue (cf. PRD 6.6), sans passer par la
          // section d'un profil précis — l'activation affichée y est
          // simplement celle du premier profil de l'appareil.
          if (profiles.isNotEmpty)
            IconButton(
              tooltip: 'Catalogue',
              icon: const Icon(Icons.menu_book_outlined),
              onPressed: () =>
                  context.push('/profiles/${profiles.first.id}/catalog'),
            ),
          PopupMenuButton<String>(
            tooltip: 'Réglages',
            onSelected: (value) {
              if (value == 'change_pin') _changePin(context);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'change_pin',
                child: Text('Changer le code parental'),
              ),
            ],
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
                              catalogStore
                                      .byId(performance.exerciseId)
                                      ?.title ??
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
        final hardestLabels = sorted
            .take(2)
            .map((entry) {
              final matches = exercise.questions.where(
                (q) => q.id == entry.key,
              );
              final question = matches.isEmpty ? null : matches.first;
              return question?.displayValue ?? entry.key;
            })
            .join(', ');

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

/// Dialogue de changement du code PIN parental (cf. PRD 6.1/6.6). Retourne
/// le nouveau code ou `null` si annulé.
class _ChangePinDialog extends StatefulWidget {
  const _ChangePinDialog({required this.currentPin});

  final String currentPin;

  @override
  State<_ChangePinDialog> createState() => _ChangePinDialogState();
}

class _ChangePinDialogState extends State<_ChangePinDialog> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_currentController.text != widget.currentPin) {
      setState(() => _error = 'Code actuel incorrect.');
      return;
    }
    final newPin = _newController.text;
    if (newPin.length != 4 || int.tryParse(newPin) == null) {
      setState(() => _error = 'Le nouveau code doit contenir 4 chiffres.');
      return;
    }
    if (newPin != _confirmController.text) {
      setState(() => _error = 'La confirmation ne correspond pas.');
      return;
    }
    Navigator.of(context).pop(newPin);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Changer le code parental'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentController,
              decoration: const InputDecoration(labelText: 'Code actuel'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            TextField(
              controller: _newController,
              decoration: const InputDecoration(
                labelText: 'Nouveau code (4 chiffres)',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(
                labelText: 'Confirmer le nouveau code',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
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
        FilledButton(onPressed: _submit, child: const Text('Enregistrer')),
      ],
    );
  }
}
