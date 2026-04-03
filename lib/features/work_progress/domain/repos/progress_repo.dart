import '../entities/models/exercise_progress.dart';

abstract class ProgressRepository {
  Future<List<String>> getTrackedExerciseNames();
  Future<ExerciseProgress> getProgressForExercise(String exerciseName);
  Future<Map<String, double>> getOverallStats();
}