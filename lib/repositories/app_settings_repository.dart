/// Réglages globaux de l'application (cf. PRD 6.1/6.6) : pour l'instant,
/// uniquement le code PIN parental.
abstract class AppSettingsRepository {
  Future<String> getPin();

  Future<void> setPin(String pin);
}
