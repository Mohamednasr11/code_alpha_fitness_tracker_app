import '../entities/workout_set.dart';
import '../repos/workout_repository.dart';

class AddSetUsecase {
  final WorkoutRepository _repository;
  AddSetUsecase(this._repository);

  Future<WorkoutSet> call(WorkoutSet set) => _repository.addSet(set);
}
