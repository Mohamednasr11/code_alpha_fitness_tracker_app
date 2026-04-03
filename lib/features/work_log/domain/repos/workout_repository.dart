import '../entities/workout_session.dart';
import '../entities/workout_set.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSession>> getAllSessions();
  Future<WorkoutSession> createSession(WorkoutSession session);
  Future<void> deleteSession(int sessionId);
  Future<WorkoutSet> addSet(WorkoutSet set);
  Future<void> deleteSet(int setId);
  Future<List<WorkoutSet>> getSetsForSession(int sessionId);
}