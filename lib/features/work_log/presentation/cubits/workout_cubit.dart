import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../exercise_library/domain/entities/exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_set.dart';
import '../../domain/usecases/add_set_use_case.dart';
import '../../domain/usecases/create_session_usecase.dart';
import '../../domain/usecases/delete_session_usecase.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../../../work_progress/presentation/cubits/progress_cubit.dart';


part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final CreateSessionUsecase createSession;
  final AddSetUsecase addSet;
  final GetSessionsUsecase getSessions;
  final DeleteSessionUsecase deleteSession;
  final ProgressCubit? progressCubit;

  WorkoutCubit({
    required this.createSession,
    required this.addSet,
    required this.getSessions,
    required this.deleteSession,
    this.progressCubit,
  }) : super(WorkoutInitial());

  Future<void> loadSessions() async {
    emit(WorkoutLoading());
    try {
      final sessions = await getSessions();
      emit(WorkoutLoaded(sessions));
      progressCubit?.load();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<WorkoutSession?> startNewSession(String name) async {
    try {
      final session = await createSession(WorkoutSession(
        name: name,
        date: DateTime.now(),
      ));
      await loadSessions();
      return session;
    } catch (e) {
      emit(WorkoutError(e.toString()));
      return null;
    }
  }

  Future<void> logSet({
    required int sessionId,
    required Exercise exercise,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    try {
      await addSet(WorkoutSet(
        sessionId: sessionId,
        exercise: exercise,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
      ));
      await loadSessions();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> removeSession(int sessionId) async {
    try {
      await deleteSession(sessionId);
      await loadSessions();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }
}