import '../entities/workout_session.dart';
import '../repos/workout_repository.dart';

class GetSessionsUsecase {
  final WorkoutRepository _repository;
  GetSessionsUsecase(this._repository);

  Future<List<WorkoutSession>> call() => _repository.getAllSessions();
}