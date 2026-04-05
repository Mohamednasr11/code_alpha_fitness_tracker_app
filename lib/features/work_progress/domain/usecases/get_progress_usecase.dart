import '../entities/models/exercise_progress.dart';
import '../repos/progress_repo.dart';

class GetProgressUsecase {
  final ProgressRepository _repository;
  GetProgressUsecase(this._repository);

  Future<List<String>> getTrackedExercises() =>
      _repository.getTrackedExerciseNames();

  Future<ExerciseProgress> forExercise(String exerciseName) =>
      _repository.getProgressForExercise(exerciseName);

  Future<Map<String, double>> overallStats() => _repository.getOverallStats();
}
