import '../repos/workout_repository.dart';

class DeleteSessionUsecase {
  final WorkoutRepository _repository;
  DeleteSessionUsecase(this._repository);

  Future<void> call(int sessionId) => _repository.deleteSession(sessionId);
}