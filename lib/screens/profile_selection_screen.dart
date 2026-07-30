import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../state/profile_store.dart';
import '../widgets/create_profile_dialog.dart';
import '../widgets/profile_avatar.dart';

/// Écran d'accueil (cf. PRD 6.1) : liste des profils enfants sur l'appareil,
/// création d'un nouveau profil, accès à l'espace parental.
class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

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
    // À la création d'un profil : toujours directement le catalogue, sans
    // présélection (cf. PRD 6.3), quel que soit le point d'entrée.
    // origin=creation : une fois "Terminé", direction la vue enfant (pas de
    // retour utile vers la sélection de profil pour un profil tout juste créé).
    context.push('/profiles/${profile.id}/catalog?origin=creation');
  }

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfileStore>().profiles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Funty'),
        actions: [
          IconButton(
            tooltip: 'Espace parental',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/parental/dashboard'),
          ),
        ],
      ),
      body: profiles.isEmpty
          ? const Center(child: Text('Aucun profil pour l\'instant.'))
          : GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                return _ProfileTile(profile: profile);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createProfile(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau profil'),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.go('/profiles/${profile.id}/home'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(avatarId: profile.avatarId, radius: 40),
          const SizedBox(height: 8),
          Text(profile.name, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
