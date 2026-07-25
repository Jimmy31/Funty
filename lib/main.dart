import 'package:flutter/material.dart';

import 'app.dart';
import 'data/database.dart';
import 'data/seed_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await seedDatabaseIfEmpty(database);
  runApp(FuntyApp(database: database));
}
