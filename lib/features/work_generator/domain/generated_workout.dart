import 'package:equatable/equatable.dart';

enum FitnessGoal { buildMuscle, loseWeight, improveEndurance, maintainFitness }

enum FitnessLevel { beginner, intermediate, advanced }

enum WorkoutDays { three, four, five }

class GeneratorInput extends Equatable {
  final FitnessGoal goal;
  final FitnessLevel level;
  final WorkoutDays daysPerWeek;

  const GeneratorInput({
    required this.goal,
    required this.level,
    required this.daysPerWeek,
  });

  @override
  List<Object?> get props => [goal, level, daysPerWeek];
}

class GeneratedWorkoutDay extends Equatable {
  final String dayName;
  final String focus;
  final List<GeneratedExercise> exercises;

  const GeneratedWorkoutDay({
    required this.dayName,
    required this.focus,
    required this.exercises,
  });

  @override
  List<Object?> get props => [dayName, focus, exercises];
}

class GeneratedExercise extends Equatable {
  final String name;
  final String muscleGroup;
  final int sets;
  final String reps;
  final String rest;

  const GeneratedExercise({
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.rest,
  });

  @override
  List<Object?> get props => [name, muscleGroup, sets, reps, rest];
}
