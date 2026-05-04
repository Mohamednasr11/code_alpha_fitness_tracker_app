import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fitness_tracker/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/routing/app_routing.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/work_generator/presentation/cubits/generator_cubit.dart';
import 'features/work_log/presentation/cubits/workout_cubit.dart';
import 'features/work_progress/presentation/cubits/progress_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }



  await initDependencies();

  runApp(
    const FitnessTrackerApp(),
  );
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WorkoutCubit>()..loadSessions()),
        BlocProvider(create: (_) => sl<ProgressCubit>()),
        BlocProvider(create: (_) => sl<GeneratorCubit>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Fitness Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.splashScreen,
          );
        },
      ),
    );
  }
}