import 'package:uuid/uuid.dart';

import '../data/catalog_seed.dart';
import '../models/profile.dart';

/// Interface de persistance des profils. Signatures en `Future` même si
/// l'implémentation en mémoire résout de façon synchrone, pour qu'une future
/// implémentation branchée sur une vraie base de données (ex. `drift`) soit
/// un remplacement direct sans toucher les appelants.
abstract class ProfileRepository {
  Future<List<Profile>> getAll();

  Future<Profile?> getById(String id);

  Future<Profile> create({required String name, required String avatarId});

  Future<void> delete(String id);
}

class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository() : _profiles = buildProfileSeed();

  final List<Profile> _profiles;
  final _uuid = const Uuid();

  @override
  Future<List<Profile>> getAll() async => List.unmodifiable(_profiles);

  @override
  Future<Profile?> getById(String id) async {
    for (final profile in _profiles) {
      if (profile.id == id) return profile;
    }
    return null;
  }

  @override
  Future<Profile> create({
    required String name,
    required String avatarId,
  }) async {
    final profile = Profile(
      id: _uuid.v4(),
      name: name,
      avatarId: avatarId,
      createdAt: DateTime.now(),
    );
    _profiles.add(profile);
    return profile;
  }

  @override
  Future<void> delete(String id) async {
    _profiles.removeWhere((p) => p.id == id);
  }
}
