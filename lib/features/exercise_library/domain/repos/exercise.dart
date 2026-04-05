import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getAllExercises();
  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup);
  Future<List<Exercise>> searchExercises(String query);
}
