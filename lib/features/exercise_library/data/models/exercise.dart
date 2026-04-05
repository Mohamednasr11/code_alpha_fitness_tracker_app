import '../../domain/entities/exercise.dart';

class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.muscleGroup,
    required super.description,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) => ExerciseModel(
        id: map['id'] as int,
        name: map['name'] as String,
        muscleGroup: map['muscle_group'] as String,
        description: map['description'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'muscle_group': muscleGroup,
        'description': description,
      };
}
