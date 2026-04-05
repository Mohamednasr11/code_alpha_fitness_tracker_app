import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_tracker/features/work_generator/domain/generated_workout.dart';
import 'package:fitness_tracker/features/work_generator/presentation/cubits/generator_cubit.dart';
import 'package:fitness_tracker/features/work_generator/presentation/pages/workout_generator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGeneratorCubit extends MockCubit<GeneratorState>
    implements GeneratorCubit {}

class FakeGeneratorInput extends Fake implements GeneratorInput {}

void main() {
  late MockGeneratorCubit mockGeneratorCubit;

  setUpAll(() {
    registerFallbackValue(FakeGeneratorInput());
  });

  setUp(() {
    mockGeneratorCubit = MockGeneratorCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<GeneratorCubit>(
        create: (context) => mockGeneratorCubit,
        child: const WorkoutGeneratorPage(),
      ),
    );
  }

  testWidgets('renders WorkoutGeneratorPage with initial form',
      (WidgetTester tester) async {
    when(() => mockGeneratorCubit.state).thenReturn(GeneratorInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Build Your Plan'), findsOneWidget);
    expect(find.text('Generate Plan'), findsOneWidget);
  });

  testWidgets('renders loading state', (WidgetTester tester) async {
    when(() => mockGeneratorCubit.state).thenReturn(GeneratorLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders results when state is GeneratorLoaded',
      (WidgetTester tester) async {
    const input = GeneratorInput(
      goal: FitnessGoal.buildMuscle,
      level: FitnessLevel.beginner,
      daysPerWeek: WorkoutDays.three,
    );
    final days = [
      const GeneratedWorkoutDay(
        dayName: 'Day 1',
        focus: 'Full Body',
        exercises: [
          GeneratedExercise(
            name: 'Push Up',
            muscleGroup: 'Chest',
            sets: 3,
            reps: '10',
            rest: '60s',
          ),
        ],
      ),
    ];

    when(() => mockGeneratorCubit.state).thenReturn(
      GeneratorLoaded(days: days, input: input),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('ظ‹ع؛â€™ع¾ Build Muscle Plan'), findsOneWidget);
    expect(find.text('Day 1'), findsOneWidget);

    await tester.tap(find.text('Day 1'));
    await tester.pumpAndSettle();

    expect(find.text('Push Up'), findsOneWidget);
  });

  testWidgets('calls generate on cubit when button is pressed',
      (WidgetTester tester) async {
    when(() => mockGeneratorCubit.state).thenReturn(GeneratorInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Generate Plan'));

    verify(() => mockGeneratorCubit.generate(any())).called(1);
  });
}
