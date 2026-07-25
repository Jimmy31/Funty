import '../models/profile.dart';

/// Interface de persistance des profils. Signatures en `Future` même si
/// certaines implémentations résolvent de façon synchrone, pour qu'une
/// implémentation différente reste un remplacement direct sans toucher les
/// appelants.
abstract class ProfileRepository {
  Future<List<Profile>> getAll();

  Future<Profile?> getById(String id);

  Future<Profile> create({required String name, required String avatarId});

  Future<void> delete(String id);
}
