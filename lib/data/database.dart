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

/// Historique des temps de réponse par question (cf. PRD 6.5) : chaque
/// tentative résolue (bonne réponse, ou révélation après 2 échecs avec sa
/// pénalité) devient une ligne. Alimente à la fois la sélection adaptative
/// et les futures statistiques par question du tableau de bord (PRD 6.6).
@DataClassName('QuestionAttemptRow')
class QuestionAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get exerciseId => text()();
  TextColumn get questionId => text()();
  IntColumn get responseTimeMs => integer()();
  DateTimeColumn get attemptedAt => dateTime()();
}

@DriftDatabase(
  tables: [Profiles, Activations, Performances, QuestionAttempts],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(questionAttempts);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'funty.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
