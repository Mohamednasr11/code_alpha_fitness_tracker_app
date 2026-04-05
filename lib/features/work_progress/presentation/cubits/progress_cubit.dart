import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/models/exercise_progress.dart';
import '../../domain/usecases/get_progress_usecase.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final GetProgressUsecase _usecase;
  ProgressCubit(this._usecase) : super(ProgressInitial());

  Future<void> load() async {
    emit(ProgressLoading());
    try {
      final stats = await _usecase.overallStats();
      final exercises = await _usecase.getTrackedExercises();

      ExerciseProgress? selectedProgress;
      if (exercises.isNotEmpty) {
        selectedProgress = await _usecase.forExercise(exercises.first);
      }

      emit(ProgressLoaded(
        stats: stats,
        trackedExercises: exercises,
        selectedProgress: selectedProgress,
        selectedExercise: exercises.isNotEmpty ? exercises.first : null,
      ));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }

  Future<void> selectExercise(String exerciseName) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    try {
      final progress = await _usecase.forExercise(exerciseName);
      emit(current.copyWith(
        selectedExercise: exerciseName,
        selectedProgress: progress,
      ));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
