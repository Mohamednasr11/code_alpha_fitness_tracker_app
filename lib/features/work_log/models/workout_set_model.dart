import '../../exercise_library/data/models/exercise.dart';
import '../domain/entities/workout_set.dart';

class WorkoutSetModel extends WorkoutSet {
  const WorkoutSetModel({
    super.id,
    required super.sessionId,
    required super.exercise,
    required super.setNumber,
    required super.reps,
    required super.weight,
  });

  factory WorkoutSetModel.fromMap(Map<String, dynamic> map) => WorkoutSetModel(
        id: map['id'] as int,
        sessionId: map['session_id'] as int,
        exercise: ExerciseModel.fromMap({
          'id': map['exercise_id'],
          'name': map['exercise_name'],
          'muscle_group': map['muscle_group'],
          'description': map['description'] ?? '',
        }),
        setNumber: map['set_number'] as int,
        reps: map['reps'] as int,
        weight: (map['weight'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'session_id': sessionId,
        'exercise_id': exercise.id,
        'set_number': setNumber,
        'reps': reps,
        'weight': weight,
      };
}
