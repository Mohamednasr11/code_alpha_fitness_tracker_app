import '../../domain/entities/exercise.dart';
import '../../domain/repos/exercise.dart';
import '../datasourcse/exercise_local_datasource.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseLocalDatasource _datasource;

  ExerciseRepositoryImpl(this._datasource);

  @override
  Future<List<Exercise>> getAllExercises() => _datasource.getAllExercises();


  @override
  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup) =>
      _datasource.getExercisesByMuscleGroup(muscleGroup);

  @override
  Future<List<Exercise>> searchExercises(String query) =>
      _datasource.searchExercises(query);
}