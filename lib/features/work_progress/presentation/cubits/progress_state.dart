part of 'progress_cubit.dart';

abstract class ProgressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final Map<String, double> stats;
  final List<String> trackedExercises;
  final ExerciseProgress? selectedProgress;
  final String? selectedExercise;

  ProgressLoaded({
    required this.stats,
    required this.trackedExercises,
    this.selectedProgress,
    this.selectedExercise,
  });

  ProgressLoaded copyWith({
    Map<String, double>? stats,
    List<String>? trackedExercises,
    ExerciseProgress? selectedProgress,
    String? selectedExercise,
  }) =>
      ProgressLoaded(
        stats: stats ?? this.stats,
        trackedExercises: trackedExercises ?? this.trackedExercises,
        selectedProgress: selectedProgress ?? this.selectedProgress,
        selectedExercise: selectedExercise ?? this.selectedExercise,
      );

  @override
  List<Object?> get props =>
      [stats, trackedExercises, selectedProgress, selectedExercise];
}

class ProgressError extends ProgressState {
  final String message;
  ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
