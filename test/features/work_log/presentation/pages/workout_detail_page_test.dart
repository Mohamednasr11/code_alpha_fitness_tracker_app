import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_tracker/features/work_log/domain/entities/workout_session.dart';
import 'package:fitness_tracker/features/work_log/presentation/cubits/workout_cubit.dart';
import 'package:fitness_tracker/features/work_log/presentation/pages/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutCubit extends MockCubit<WorkoutState>
    implements WorkoutCubit {}

void main() {
  late MockWorkoutCubit mockWorkoutCubit;
  final session = WorkoutSession(
    id: 1,
    name: 'Chest Day',
    date: DateTime.now(),
    sets: const [],
  );

  setUp(() {
    mockWorkoutCubit = MockWorkoutCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<WorkoutCubit>(
        create: (context) => mockWorkoutCubit,
        child: WorkoutDetailPage(session: session),
      ),
    );
  }

  testWidgets('renders WorkoutDetailPage with empty sets',
      (WidgetTester tester) async {
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutLoaded([session]));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Chest Day'), findsOneWidget);
    expect(find.text('No sets logged yet'), findsOneWidget);
  });
}
