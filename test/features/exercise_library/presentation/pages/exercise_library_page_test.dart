import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_tracker/core/di/service_locator.dart';
import 'package:fitness_tracker/features/exercise_library/presentation/cubit/exercise_cubit.dart';
import 'package:fitness_tracker/features/exercise_library/presentation/pages/exercise_library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseCubit extends MockCubit<ExerciseState>
    implements ExerciseCubit {}

void main() {
  late MockExerciseCubit mockExerciseCubit;

  setUp(() async {
    mockExerciseCubit = MockExerciseCubit();
    final sl = GetIt.instance;
    sl.registerFactory<ExerciseCubit>(() => mockExerciseCubit);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ExerciseLibraryPage(),
    );
  }

  testWidgets('renders ExerciseLibraryPage and loads exercises',
      (WidgetTester tester) async {
    when(() => mockExerciseCubit.state).thenReturn(ExerciseInitial());
    when(() => mockExerciseCubit.loadExercises()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Exercise Library'), findsOneWidget);
    verify(() => mockExerciseCubit.loadExercises()).called(1);
  });
}
