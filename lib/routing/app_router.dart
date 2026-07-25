import 'package:go_router/go_router.dart';

import '../screens/catalog_screen.dart';
import '../screens/child_home_screen.dart';
import '../screens/exercise_runner_screen.dart';
import '../screens/parental_dashboard_screen.dart';
import '../screens/parental_pin_screen.dart';
import '../screens/profile_selection_screen.dart';

/// Table de routes (cf. plan de squelette d'écrans). L'écran de spike Vosk
/// n'y figure pas : il est atteint uniquement en debug via un
/// `Navigator.push` classique depuis [ProfileSelectionScreen].
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProfileSelectionScreen()),
    GoRoute(
      path: '/profiles/:profileId/catalog',
      builder: (context, state) => CatalogScreen(
        profileId: state.pathParameters['profileId']!,
      ),
    ),
    GoRoute(
      path: '/profiles/:profileId/home',
      builder: (context, state) => ChildHomeScreen(
        profileId: state.pathParameters['profileId']!,
      ),
    ),
    GoRoute(
      path: '/profiles/:profileId/exercise/:exerciseId',
      builder: (context, state) => ExerciseRunnerScreen(
        profileId: state.pathParameters['profileId']!,
        exerciseId: state.pathParameters['exerciseId']!,
      ),
    ),
    GoRoute(
      path: '/parental/pin',
      builder: (context, state) => const ParentalPinScreen(),
    ),
    GoRoute(
      path: '/parental/dashboard',
      builder: (context, state) => const ParentalDashboardScreen(),
    ),
  ],
);
