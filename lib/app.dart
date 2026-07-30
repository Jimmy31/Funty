import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database.dart';
import 'repositories/drift_catalog_repository.dart';
import 'repositories/drift_performance_repository.dart';
import 'repositories/drift_profile_repository.dart';
import 'repositories/drift_question_stats_repository.dart';
import 'repositories/question_stats_repository.dart';
import 'routing/app_router.dart';
import 'state/catalog_store.dart';
import 'state/performance_store.dart';
import 'state/profile_store.dart';

class FuntyApp extends StatelessWidget {
  const FuntyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileStore(DriftProfileRepository(database)),
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogStore(DriftCatalogRepository(database)),
        ),
        ChangeNotifierProvider(
          create: (_) => PerformanceStore(DriftPerformanceRepository(database)),
        ),
        Provider<QuestionStatsRepository>(
          create: (_) => DriftQuestionStatsRepository(database),
        ),
      ],
      child: MaterialApp.router(
        title: 'Funty',
        // Le bandeau "DEBUG" masque le coin supérieur droit des écrans et
        // n'apporte rien pendant les essais sur appareil.
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
