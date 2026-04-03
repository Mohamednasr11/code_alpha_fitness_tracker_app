import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_set.dart';
import '../../domain/repos/workout_repository.dart';
import '../../models/workout_session_model.dart';
import '../../models/workout_set_model.dart';
import '../datasources/workout_local_datasource.dart';


class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDatasource _datasource;
  WorkoutRepositoryImpl(this._datasource);

  @override
  Future<List<WorkoutSession>> getAllSessions() =>
      _datasource.getAllSessions();

  @override
  Future<WorkoutSession> createSession(WorkoutSession session) =>
      _datasource.createSession(WorkoutSessionModel(
        name: session.name,
        date: session.date,
        notes: session.notes,
        durationMinutes: session.durationMinutes,
      ));

  @override
  Future<void> deleteSession(int sessionId) =>
      _datasource.deleteSession(sessionId);

  @override
  Future<WorkoutSet> addSet(WorkoutSet set) =>
      _datasource.addSet(WorkoutSetModel(
        sessionId: set.sessionId,
        exercise: set.exercise,
        setNumber: set.setNumber,
        reps: set.reps,
        weight: set.weight,
      ));

  @override
  Future<void> deleteSet(int setId) => _datasource.deleteSet(setId);

  @override
  Future<List<WorkoutSet>> getSetsForSession(int sessionId) =>
      _datasource.getSetsForSession(sessionId);
}