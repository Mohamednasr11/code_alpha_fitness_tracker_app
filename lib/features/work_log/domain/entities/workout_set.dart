import 'package:equatable/equatable.dart';
import '../../../exercise_library/domain/entities/exercise.dart';

class WorkoutSet extends Equatable {
  final int? id;
  final int sessionId;
  final Exercise exercise;
  final int setNumber;
  final int reps;
  final double weight;

  const WorkoutSet({
    this.id,
    required this.sessionId,
    required this.exercise,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  @override
  List<Object?> get props => [id, sessionId, exercise, setNumber, reps, weight];
}
