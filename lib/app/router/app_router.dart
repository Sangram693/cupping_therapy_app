import 'package:go_router/go_router.dart';

import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/therapy/presentation/screens/therapy_services_screen.dart';
import '../../features/training/presentation/screens/training_programs_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter();

  GoRouter get router => _router;

  final GoRouter _router = GoRouter(
    initialLocation: '/${RouteNames.splash}',
    routes: <RouteBase>[
      GoRoute(
        path: '/${RouteNames.splash}',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.home}',
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.login}',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.register}',
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.therapy}',
        name: RouteNames.therapy,
        builder: (context, state) => const TherapyServicesScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.appointments}',
        name: RouteNames.appointments,
        builder: (context, state) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.training}',
        name: RouteNames.training,
        builder: (context, state) => const TrainingProgramsScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.profile}',
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.settings}',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
