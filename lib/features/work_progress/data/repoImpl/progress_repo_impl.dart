

import '../../domain/entities/models/exercise_progress.dart';
import '../../domain/repos/progress_repo.dart';
import '../progress_local_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDatasource _datasource;
  ProgressRepositoryImpl(this._datasource);

  @override
  Future<List<String>> getTrackedExerciseNames() =>
      _datasource.getTrackedExerciseNames();

  @override
  Future<ExerciseProgress> getProgressForExercise(String exerciseName) =>
      _datasource.getProgressForExercise(exerciseName);

  @override
  Future<Map<String, double>> getOverallStats() =>
      _datasource.getOverallStats();
}