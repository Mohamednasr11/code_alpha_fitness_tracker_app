part of 'generator_cubit.dart';

abstract class GeneratorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GeneratorInitial extends GeneratorState {}

class GeneratorLoading extends GeneratorState {}

class GeneratorLoaded extends GeneratorState {
  final List<GeneratedWorkoutDay> days;
  final GeneratorInput input;

  GeneratorLoaded({required this.days, required this.input});

  @override
  List<Object?> get props => [days, input];
}

class GeneratorError extends GeneratorState {
  final String message;
  GeneratorError(this.message);

  @override
  List<Object?> get props => [message];
}