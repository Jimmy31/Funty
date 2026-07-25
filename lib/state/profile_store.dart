import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class ProfileStore extends ChangeNotifier {
  ProfileStore(this._repository) {
    _load();
  }

  final ProfileRepository _repository;
  List<Profile> _profiles = [];

  List<Profile> get profiles => _profiles;

  Future<void> _load() async {
    _profiles = await _repository.getAll();
    notifyListeners();
  }

  Profile? byId(String id) {
    for (final profile in _profiles) {
      if (profile.id == id) return profile;
    }
    return null;
  }

  Future<Profile> createProfile({
    required String name,
    required String avatarId,
  }) async {
    final profile = await _repository.create(name: name, avatarId: avatarId);
    await _load();
    return profile;
  }

  Future<void> deleteProfile(String id) async {
    await _repository.delete(id);
    await _load();
  }
}
