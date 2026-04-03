import 'package:flutter/material.dart';
import '../../features/exercise_library/presentation/pages/exercise_library_page.dart';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const MainShell());

      case workoutDetail:
        final session = settings.arguments as WorkoutSession?;
        return _buildRoute(WorkoutDetailPage(session: session));

      case exerciseLibrary:
        return _buildRoute(const ExerciseLibraryPage());

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