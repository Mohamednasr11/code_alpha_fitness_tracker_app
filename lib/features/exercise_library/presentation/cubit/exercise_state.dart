part of 'exercise_cubit.dart';



abstract class ExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final List<Exercise> filtered;
  final String selectedMuscleGroup;

  ExerciseLoaded({
    required this.exercises,
    required this.filtered,
    required this.selectedMuscleGroup,
  });

  @override
  List<Object?> get props => [exercises, filtered, selectedMuscleGroup];
}

class ExerciseError extends ExerciseState {
  final String message;
  ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}