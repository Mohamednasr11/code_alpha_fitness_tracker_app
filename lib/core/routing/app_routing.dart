import 'package:fitness_tracker/features/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/login/presentation/login_screen.dart';
import '../../features/exercise_library/presentation/pages/exercise_library_page.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/work_generator/presentation/pages/workout_generator_page.dart';
import '../../features/work_log/domain/entities/workout_session.dart';
import '../../features/work_log/presentation/pages/workout_detail_page.dart';
import '../../main_shell.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String workoutDetail = '/workout-detail';
  static const String exerciseLibrary = '/exercise-library';
  static const String workoutGenerator = '/workout-generator';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const MainShell());

      case workoutDetail:
        final session = settings.arguments as WorkoutSession?;
        return _buildRoute(WorkoutDetailPage(session: session));

      case exerciseLibrary:
        return _buildRoute(const ExerciseLibraryPage());
      case splashScreen:
        return _buildRoute(const SplashScreen());
      case loginScreen:
        return _buildRoute(const LoginScreen());
      case registerScreen:
        return _buildRoute(const RegisterScreen());

      case workoutGenerator:
        return _buildRoute(const WorkoutGeneratorPage());

      default:
        return _buildRoute(const MainShell());
    }
  }

  static MaterialPageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
