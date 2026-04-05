import '../../../../core/database/database_helper.dart';
import '../models/exercise.dart';

abstract class ExerciseLocalDatasource {
  Future<List<ExerciseModel>> getAllExercises();
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(String muscleGroup);
  Future<List<ExerciseModel>> searchExercises(String query);
}

class ExerciseLocalDatasourceImpl implements ExerciseLocalDatasource {
  final DatabaseHelper _db;

  ExerciseLocalDatasourceImpl(this._db);

  @override
  Future<List<ExerciseModel>> getAllExercises() async {
    final db = await _db.database;
    final result = await db.query('exercises', orderBy: 'muscle_group, name');
    return result.map((e) => ExerciseModel.fromMap(e)).toList();
  }

  @override
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(
      String muscleGroup) async {
    final db = await _db.database;
    final result = await db.query(
      'exercises',
      where: 'muscle_group = ?',
      whereArgs: [muscleGroup],
      orderBy: 'name',
    );
    return result.map((e) => ExerciseModel.fromMap(e)).toList();
  }

  @override
  Future<List<ExerciseModel>> searchExercises(String query) async {
    final db = await _db.database;
    final result = await db.query(
      'exercises',
      where: 'name LIKE ? OR muscle_group LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name',
    );
    return result.map((e) => ExerciseModel.fromMap(e)).toList();
  }
}
