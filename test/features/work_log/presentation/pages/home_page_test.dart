import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_tracker/features/work_log/presentation/cubits/workout_cubit.dart';
import 'package:fitness_tracker/features/work_log/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutCubit extends MockCubit<WorkoutState> implements WorkoutCubit {}

void main() {
  late MockWorkoutCubit mockWorkoutCubit;

  setUp(() {
    mockWorkoutCubit = MockWorkoutCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<WorkoutCubit>(
        create: (context) => mockWorkoutCubit,
        child: const HomePage(),
      ),
    );
  }

  testWidgets('renders HomePage with empty state', (WidgetTester tester) async {
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutLoaded(const []));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No workouts yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('renders loading state', (WidgetTester tester) async {
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
