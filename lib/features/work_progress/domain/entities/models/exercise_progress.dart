import 'package:equatable/equatable.dart';

class ExerciseProgress extends Equatable {
  final String exerciseName;
  final List<ProgressEntry> entries;

  const ExerciseProgress({
    required this.exerciseName,
    required this.entries,
  });

  @override
  List<Object?> get props => [exerciseName, entries];
}

class ProgressEntry extends Equatable {
  final DateTime date;
  final double maxWeight;
  final int totalReps;
  final double totalVolume;

  const ProgressEntry({
    required this.date,
    required this.maxWeight,
    required this.totalReps,
    required this.totalVolume,
  });

  @override
  List<Object?> get props => [date, maxWeight, totalReps, totalVolume];
}
