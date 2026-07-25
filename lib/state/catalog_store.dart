import 'package:flutter/foundation.dart';

import '../models/exercise.dart';
import '../repositories/catalog_repository.dart';

/// État du catalogue et de l'activation par profil (cf. PRD 6.2/6.3).
class CatalogStore extends ChangeNotifier {
  CatalogStore(this._repository) {
    _loadExercises();
  }

  final CatalogRepository _repository;
  List<Exercise> _exercises = [];
  final Map<String, Set<String>> _activationCache = {};

  List<Exercise> get exercises => _exercises;

  Future<void> _loadExercises() async {
    _exercises = await _repository.getAllExercises();
    notifyListeners();
  }

  Exercise? byId(String id) {
    for (final exercise in _exercises) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  /// À appeler (ex. dans initState) avant de lire [isActive]/[activeIdsFor]
  /// pour un profil donné.
  Future<void> ensureActivationLoaded(String profileId) async {
    if (_activationCache.containsKey(profileId)) return;
    // Copie mutable : le repository renvoie un Set.unmodifiable, alors que
    // toggleActive doit pouvoir ajouter/retirer directement dans le cache.
    _activationCache[profileId] = {
      ...await _repository.getActiveExerciseIds(profileId),
    };
    notifyListeners();
  }

  Set<String> activeIdsFor(String profileId) =>
      _activationCache[profileId] ?? const {};

  bool isActive(String profileId, String exerciseId) =>
      activeIdsFor(profileId).contains(exerciseId);

  /// Ajout et retrait sont le même geste (un toggle), symétrie exigée par
  /// PRD 6.3.
  Future<void> toggleActive(String profileId, String exerciseId) async {
    final currentlyActive = isActive(profileId, exerciseId);
    await _repository.setActive(profileId, exerciseId, !currentlyActive);
    final set = _activationCache.putIfAbsent(profileId, () => {});
    if (currentlyActive) {
      set.remove(exerciseId);
    } else {
      set.add(exerciseId);
    }
    notifyListeners();
  }

  /// Réglage parental d'un exercice (cf. PRD 6.6/6.7) : nombre de questions
  /// par série et seuils bronze/argent/or, communs à tous les profils.
  Future<void> updateExerciseSettings(
    String exerciseId, {
    required int questionsPerSeries,
    required Duration bronzeThreshold,
    required Duration silverThreshold,
    required Duration goldThreshold,
  }) async {
    await _repository.updateExerciseSettings(
      exerciseId,
      questionsPerSeries: questionsPerSeries,
      bronzeThreshold: bronzeThreshold,
      silverThreshold: silverThreshold,
      goldThreshold: goldThreshold,
    );
    await _loadExercises();
  }
}
