import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_tracker/features/work_generator/presentation/cubits/generator_cubit.dart';
import 'package:fitness_tracker/features/work_log/presentation/cubits/workout_cubit.dart';
import 'package:fitness_tracker/features/work_progress/presentation/cubits/progress_cubit.dart';
import 'package:fitness_tracker/main.dart';
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
    sl.reset(); // Full reset to avoid "already registered" errors
    
    sl.registerFactory<WorkoutCubit>(() => mockWorkoutCubit);
    sl.registerFactory<ProgressCubit>(() => mockProgressCubit);
    sl.registerFactory<GeneratorCubit>(() => mockGeneratorCubit);

    when(() => mockWorkoutCubit.state).thenReturn(WorkoutInitial());
    when(() => mockWorkoutCubit.loadSessions()).thenAnswer((_) async {});
    when(() => mockProgressCubit.state).thenReturn(ProgressInitial());
    when(() => mockProgressCubit.load()).thenAnswer((_) async {});
    when(() => mockGeneratorCubit.state).thenReturn(GeneratorInitial());
  });

  testWidgets('App smoke test - renders FitnessTrackerApp', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessTrackerApp());
    expect(find.byType(FitnessTrackerApp), findsOneWidget);
  });
}
