import '../../../../core/database/database_helper.dart';
import '../../models/workout_session_model.dart';
import '../../models/workout_set_model.dart';

abstract class WorkoutLocalDatasource {
  Future<List<WorkoutSessionModel>> getAllSessions();
  Future<WorkoutSessionModel> createSession(WorkoutSessionModel session);
  Future<void> deleteSession(int sessionId);
  Future<WorkoutSetModel> addSet(WorkoutSetModel set);
  Future<void> deleteSet(int setId);
  Future<List<WorkoutSetModel>> getSetsForSession(int sessionId);
}

class WorkoutLocalDatasourceImpl implements WorkoutLocalDatasource {
  final DatabaseHelper _db;
  WorkoutLocalDatasourceImpl(this._db);

  @override
  Future<List<WorkoutSessionModel>> getAllSessions() async {
    final db = await _db.database;
    final sessions = await db.query(
      'workout_sessions',
      orderBy: 'date DESC',
    );

    final result = <WorkoutSessionModel>[];
    for (final s in sessions) {
      final sets = await getSetsForSession(s['id'] as int);
      result.add(WorkoutSessionModel.fromMap(s, sets: sets));
    }
    return result;
  }

  @override
  Future<WorkoutSessionModel> createSession(WorkoutSessionModel session) async {
    final db = await _db.database;
    final id = await db.insert('workout_sessions', session.toMap());
    return WorkoutSessionModel.fromMap({...session.toMap(), 'id': id});
  }

  @override
  Future<void> deleteSession(int sessionId) async {
    final db = await _db.database;
    await db.delete(
      'workout_sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  @override
  Future<WorkoutSetModel> addSet(WorkoutSetModel set) async {
    final db = await _db.database;
    final id = await db.insert('workout_sets', set.toMap());
    return WorkoutSetModel.fromMap({
      ...set.toMap(),
      'id': id,
      'exercise_name': set.exercise.name,
      'muscle_group': set.exercise.muscleGroup,
      'description': set.exercise.description,
    });
  }

  @override
  Future<void> deleteSet(int setId) async {
    final db = await _db.database;
    await db.delete('workout_sets', where: 'id = ?', whereArgs: [setId]);
  }

  @override
  Future<List<WorkoutSetModel>> getSetsForSession(int sessionId) async {
    final db = await _db.database;
    final result = await db.rawQuery('''
      SELECT 
        ws.id, ws.session_id, ws.set_number, ws.reps, ws.weight,
        ws.exercise_id,
        e.name AS exercise_name,
        e.muscle_group,
        e.description
      FROM workout_sets ws
      JOIN exercises e ON ws.exercise_id = e.id
      WHERE ws.session_id = ?
      ORDER BY ws.set_number ASC
    ''', [sessionId]);
    return result.map((r) => WorkoutSetModel.fromMap(r)).toList();
  }
}
