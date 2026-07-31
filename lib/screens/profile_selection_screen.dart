import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../state/profile_store.dart';
import '../widgets/profile_avatar.dart';

/// Écran d'accueil (cf. PRD 6.1) : liste des profils enfants sur l'appareil
/// et accès à l'espace parental. La création d'un profil n'est proposée que
/// depuis l'espace parental : c'est un geste de parent, et le doublon ici
/// n'apportait rien.
class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  static const _marge = 20.0;
  static const _ecart = 20.0;

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
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Aucun profil pour l\'instant.\n'
                  'Créez-en un depuis l\'espace parental, en haut à droite.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          // Un profil par ligne, chacun occupant la moitié de la hauteur
          // visible : deux enfants tiennent donc à l'écran sans défilement,
          // et les suivants défilent. La hauteur de tuile est calculée sur la
          // place réellement disponible plutôt que fixée en dur, sans quoi
          // elle ne vaudrait que pour un seul format d'écran.
          // SafeArea : sans elle, la hauteur mesurée inclut la bande de la
          // barre de navigation système, et le second profil se retrouve
          // calculé pour une place qu'il n'a pas — son prénom passait dessous.
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final hauteurTuile =
                      (constraints.maxHeight - _marge * 2 - _ecart) / 2;
                  return ListView.separated(
                    padding: const EdgeInsets.all(_marge),
                    itemCount: profiles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: _ecart),
                    itemBuilder: (context, index) => SizedBox(
                      height: hauteurTuile,
                      child: _ProfileTile(profile: profiles[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile});

  /// Hauteur réservée au prénom sous l'avatar (ligne de texte + son écart).
  static const _placeDuNom = 56.0;

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    // L'avatar se dimensionne sur la tuile plutôt que sur un rayon fixe :
    // c'est la liste qui décide de la place, et l'avatar la remplit sans
    // risque de débordement, quel que soit le format d'écran. On lui réserve
    // [_placeDuNom] sous lui, sinon le cercle mange la ligne du prénom.
    return LayoutBuilder(
      builder: (context, constraints) {
        final diametre = min(
          constraints.maxWidth,
          constraints.maxHeight - _placeDuNom,
        );
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.go('/profiles/${profile.id}/home'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileAvatar(avatarId: profile.avatarId, radius: diametre / 2),
              const SizedBox(height: 12),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
