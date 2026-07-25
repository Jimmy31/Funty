import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/catalog_repository.dart';
import 'repositories/performance_repository.dart';
import 'repositories/profile_repository.dart';
import 'routing/app_router.dart';
import 'state/catalog_store.dart';
import 'state/performance_store.dart';
import 'state/profile_store.dart';

class FuntyApp extends StatelessWidget {
  const FuntyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileStore(InMemoryProfileRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogStore(InMemoryCatalogRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => PerformanceStore(InMemoryPerformanceRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Funty',
        theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
        routerConfig: appRouter,
      ),
    );
  }
}
