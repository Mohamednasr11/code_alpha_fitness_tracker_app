import '../entities/exercise.dart';
import '../repos/exercise.dart';

class GetExercisesUseCase {
  final ExerciseRepository _repository;

  GetExercisesUseCase(this._repository);

  Future<List<Exercise>> all() => _repository.getAllExercises();

  Future<List<Exercise>> byMuscleGroup(String muscleGroup) =>
      _repository.getExercisesByMuscleGroup(muscleGroup);

  Future<List<Exercise>> search(String query) =>
      _repository.searchExercises(query);
}
