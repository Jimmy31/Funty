import 'package:uuid/uuid.dart';

import '../data/database.dart';
import '../models/profile.dart';
import 'profile_repository.dart';

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Future<List<Profile>> getAll() async {
    final rows = await _db.select(_db.profiles).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Profile?> getById(String id) async {
    final row = await (_db.select(
      _db.profiles,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toModel(row);
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
    await _db
        .into(_db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: profile.id,
            name: profile.name,
            avatarId: profile.avatarId,
            createdAt: profile.createdAt,
          ),
        );
    return profile;
  }

  @override
  Future<void> delete(String id) async {
    // Nettoyage en cascade : sans ça, activations/performances d'un profil
    // supprimé resteraient orphelines dans la base (contrairement à
    // l'ancienne version en mémoire, où tout disparaissait de toute façon).
    await _db.transaction(() async {
      await (_db.delete(
        _db.performances,
      )..where((t) => t.profileId.equals(id))).go();
      await (_db.delete(
        _db.activations,
      )..where((t) => t.profileId.equals(id))).go();
      await (_db.delete(_db.profiles)..where((t) => t.id.equals(id))).go();
    });
  }

  Profile _toModel(ProfileRow row) => Profile(
    id: row.id,
    name: row.name,
    avatarId: row.avatarId,
    createdAt: row.createdAt,
  );
}
