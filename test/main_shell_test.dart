import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_tracker/core/di/service_locator.dart';
import 'package:fitness_tracker/features/work_generator/presentation/cubits/generator_cubit.dart';
import 'package:fitness_tracker/features/work_log/presentation/cubits/workout_cubit.dart';
import 'package:fitness_tracker/features/work_progress/presentation/cubits/progress_cubit.dart';
import 'package:fitness_tracker/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutCubit extends MockCubit<WorkoutState> implements WorkoutCubit {}
class MockProgressCubit extends MockCubit<ProgressState> implements ProgressCubit {}
class MockGeneratorCubit extends MockCubit<GeneratorState> implements GeneratorCubit {}

void main() {
  late MockWorkoutCubit mockWorkoutCubit;
  late MockProgressCubit mockProgressCubit;
  late MockGeneratorCubit mockGeneratorCubit;

  setUp(() {
    mockWorkoutCubit = MockWorkoutCubit();
    mockProgressCubit = MockProgressCubit();
    mockGeneratorCubit = MockGeneratorCubit();

    final sl = GetIt.instance;
    // Clear registration to avoid duplicates or missing registrations
    if (sl.isRegistered<WorkoutCubit>()) sl.unregister<WorkoutCubit>();
    if (sl.isRegistered<ProgressCubit>()) sl.unregister<ProgressCubit>();
    if (sl.isRegistered<GeneratorCubit>()) sl.unregister<GeneratorCubit>();
    
    sl.registerFactory<WorkoutCubit>(() => mockWorkoutCubit);
    sl.registerFactory<ProgressCubit>(() => mockProgressCubit);
    sl.registerFactory<GeneratorCubit>(() => mockGeneratorCubit);

    when(() => mockWorkoutCubit.state).thenReturn(WorkoutInitial());
    when(() => mockWorkoutCubit.loadSessions()).thenAnswer((_) async {});
    
    when(() => mockProgressCubit.state).thenReturn(ProgressInitial());
    when(() => mockProgressCubit.load()).thenAnswer((_) async {});
    
    when(() => mockGeneratorCubit.state).thenReturn(GeneratorInitial());
  });

  tearDown(() async {
    // Reset sl after each test
    await GetIt.instance.reset();
  });

  testWidgets('renders MainShell and shows initial page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell()));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
