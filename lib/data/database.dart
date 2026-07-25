import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Profils enfants créés localement sur l'appareil (cf. PRD 6.1).
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatarId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Un exercice activé pour un profil (présence de la ligne = actif). Le
/// contenu du catalogue reste défini en code (cf. catalog_seed.dart) : seule
/// l'activation par profil est propre à l'utilisateur et doit persister.
@DataClassName('ActivationRow')
class Activations extends Table {
  TextColumn get profileId => text()();
  TextColumn get exerciseId => text()();

  @override
  Set<Column> get primaryKey => {profileId, exerciseId};
}

/// Agrégat de performance par (profil, exercice) (cf. PRD 6.6).
@DataClassName('PerformanceRow')
class Performances extends Table {
  TextColumn get profileId => text()();
  TextColumn get exerciseId => text()();
  IntColumn get badgeLevel => integer()();
  IntColumn get successRatePercent => integer()();
  IntColumn get attemptsCount => integer()();
  DateTimeColumn get lastPracticedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {profileId, exerciseId};
}

@DriftDatabase(tables: [Profiles, Activations, Performances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'funty.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
