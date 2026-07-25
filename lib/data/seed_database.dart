import 'package:drift/drift.dart';

import 'catalog_seed.dart';
import 'database.dart';

/// Peuple la base au tout premier lancement (base vide), pour ne pas avoir
/// un écran vide en sortie d'installation. Sans effet sur les lancements
/// suivants — c'est ce qui distingue ce squelette de la version en mémoire
/// précédente, où les mêmes profils factices étaient recréés à chaque
/// démarrage.
Future<void> seedDatabaseIfEmpty(AppDatabase db) async {
  final existingProfiles = await db.select(db.profiles).get();
  if (existingProfiles.isNotEmpty) return;

  await db.transaction(() async {
    for (final profile in buildProfileSeed()) {
      await db
          .into(db.profiles)
          .insert(
            ProfilesCompanion.insert(
              id: profile.id,
              name: profile.name,
              avatarId: profile.avatarId,
              createdAt: profile.createdAt,
            ),
          );
    }

    for (final entry in buildActivationSeed().entries) {
      for (final exerciseId in entry.value) {
        await db
            .into(db.activations)
            .insert(
              ActivationsCompanion.insert(
                profileId: entry.key,
                exerciseId: exerciseId,
              ),
            );
      }
    }

    for (final performance in buildPerformanceSeed()) {
      await db
          .into(db.performances)
          .insert(
            PerformancesCompanion.insert(
              profileId: performance.profileId,
              exerciseId: performance.exerciseId,
              badgeLevel: performance.badgeLevel,
              successRatePercent: performance.successRatePercent,
              attemptsCount: performance.attemptsCount,
              lastPracticedAt: Value(performance.lastPracticedAt),
            ),
          );
    }
  });
}
