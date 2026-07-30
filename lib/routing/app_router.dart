import 'package:go_router/go_router.dart';

import '../screens/catalog_screen.dart';
import '../screens/child_home_screen.dart';
import '../screens/exercise_runner_screen.dart';
import '../screens/exercise_stats_screen.dart';
import '../screens/parental_dashboard_screen.dart';
import '../screens/profile_selection_screen.dart';

/// Table de routes (cf. plan de squelette d'écrans).
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProfileSelectionScreen(),
    ),
    // Catalogue consulté globalement depuis l'espace parental : réglages
    // d'exercice seulement, sans activation (celle-ci se fait profil par
    // profil, cf. route ci-dessous).
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogScreen(),
    ),
    GoRoute(
      path: '/profiles/:profileId/catalog',
      builder: (context, state) =>
          CatalogScreen(profileId: state.pathParameters['profileId']!),
    ),
    GoRoute(
      path: '/profiles/:profileId/home',
      builder: (context, state) =>
          ChildHomeScreen(profileId: state.pathParameters['profileId']!),
    ),
    GoRoute(
      path: '/profiles/:profileId/exercise/:exerciseId',
      builder: (context, state) => ExerciseRunnerScreen(
        profileId: state.pathParameters['profileId']!,
        exerciseId: state.pathParameters['exerciseId']!,
      ),
    ),
    GoRoute(
      path: '/parental/dashboard',
      builder: (context, state) => const ParentalDashboardScreen(),
    ),
    GoRoute(
      path: '/parental/stats/:profileId/:exerciseId',
      builder: (context, state) => ExerciseStatsScreen(
        profileId: state.pathParameters['profileId']!,
        exerciseId: state.pathParameters['exerciseId']!,
      ),
    ),
  ],
);
