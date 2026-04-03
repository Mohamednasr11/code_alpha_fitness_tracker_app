
import '../entities/workout_session.dart';
import '../repos/workout_repository.dart';

class CreateSessionUsecase {
  final WorkoutRepository _repository;
  CreateSessionUsecase(this._repository);

  Future<WorkoutSession> call(WorkoutSession session) =>
      _repository.createSession(session);
}