import 'package:flutter/foundation.dart';

import '../repositories/app_settings_repository.dart';

/// Réglages globaux (cf. PRD 6.1/6.6) : pour l'instant, le code PIN
/// parental, modifiable depuis l'espace parental.
class AppSettingsStore extends ChangeNotifier {
  AppSettingsStore(this._repository) {
    _load();
  }

  final AppSettingsRepository _repository;
  String? _pin;

  /// `null` tant que le chargement initial n'est pas terminé.
  String? get pin => _pin;

  Future<void> _load() async {
    _pin = await _repository.getPin();
    notifyListeners();
  }

  Future<void> updatePin(String newPin) async {
    await _repository.setPin(newPin);
    _pin = newPin;
    notifyListeners();
  }
}
