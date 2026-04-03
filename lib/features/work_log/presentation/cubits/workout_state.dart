part of 'workout_cubit.dart';

abstract class WorkoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<WorkoutSession> sessions;
  WorkoutLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}