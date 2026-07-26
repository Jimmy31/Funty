import 'package:drift/drift.dart';

import '../data/database.dart';
import 'app_settings_repository.dart';

class DriftAppSettingsRepository implements AppSettingsRepository {
  DriftAppSettingsRepository(this._db);

  final AppDatabase _db;

  // Placeholder d'origine du spike (cf. PRD 6.1) — valeur de départ tant
  // que le parent n'a pas défini son propre code.
  static const _defaultPin = '1234';
  static const _rowId = 0;

  @override
  Future<String> getPin() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(_rowId))).getSingleOrNull();
    return row?.pinCode ?? _defaultPin;
  }

  @override
  Future<void> setPin(String pin) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(id: const Value(_rowId), pinCode: pin),
        );
  }
}
