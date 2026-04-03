import '../../../../core/database/database_helper.dart';
import '../domain/entities/models/exercise_progress.dart';

abstract class ProgressLocalDatasource {
  Future<List<String>> getTrackedExerciseNames();
  Future<ExerciseProgress> getProgressForExercise(String exerciseName);
  Future<Map<String, double>> getOverallStats();
}

class ProgressLocalDatasourceImpl implements ProgressLocalDatasource {
  final DatabaseHelper _db;
  ProgressLocalDatasourceImpl(this._db);

  @override
  Future<List<String>> getTrackedExerciseNames() async {
    final db = await _db.database;
    final result = await db.rawQuery('''
      SELECT DISTINCT e.name
      FROM workout_sets ws
      JOIN exercises e ON ws.exercise_id = e.id
      ORDER BY e.name
    ''');
    return result.map((r) => r['name'] as String).toList();
  }

  @override
  Future<ExerciseProgress> getProgressForExercise(
      String exerciseName) async {
    final db = await _db.database;

    // Get per-session aggregates for this exercise
    final result = await db.rawQuery('''
      SELECT
        s.date,
        MAX(ws.weight) AS max_weight,
        SUM(ws.reps)   AS total_reps,
        SUM(ws.reps * ws.weight) AS total_volume
      FROM workout_sets ws
      JOIN workout_sessions s ON ws.session_id = s.id
      JOIN exercises e ON ws.exercise_id = e.id
      WHERE e.name = ?
      GROUP BY s.id
      ORDER BY s.date ASC
    ''', [exerciseName]);

    final entries = result.map((r) {
      return ProgressEntry(
        date: DateTime.parse(r['date'] as String),
        maxWeight: (r['max_weight'] as num).toDouble(),
        totalReps: (r['total_reps'] as num).toInt(),
        totalVolume: (r['total_volume'] as num).toDouble(),
      );
    }).toList();

    return ExerciseProgress(exerciseName: exerciseName, entries: entries);
  }

  @override
  Future<Map<String, double>> getOverallStats() async {
    final db = await _db.database;

    final totalSessions = (await db.rawQuery(
        'SELECT COUNT(*) as c FROM workout_sessions'))
        .first['c'] as int;

    final totalSets =
    (await db.rawQuery('SELECT COUNT(*) as c FROM workout_sets'))
        .first['c'] as int;

    final volumeResult = await db.rawQuery(
        'SELECT SUM(reps * weight) as v FROM workout_sets');
    final totalVolume =
        (volumeResult.first['v'] as num?)?.toDouble() ?? 0.0;

    final exercisesResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT exercise_id) as c FROM workout_sets
    ''');
    final uniqueExercises =
        (exercisesResult.first['c'] as int?)?.toDouble() ?? 0;

    return {
      'total_sessions': totalSessions.toDouble(),
      'total_sets': totalSets.toDouble(),
      'total_volume': totalVolume,
      'unique_exercises': uniqueExercises,
    };
  }
}