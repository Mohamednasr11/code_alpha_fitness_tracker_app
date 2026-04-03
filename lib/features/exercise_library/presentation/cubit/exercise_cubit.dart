import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../exercise_library/domain/entities/exercise.dart';
import '../../../exercise_library/domain/usecases/exercise.dart';
part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final GetExercisesUsecase _usecase;

  ExerciseCubit(this._usecase) : super(ExerciseInitial());

  String _selectedMuscleGroup = 'All';
  String _searchQuery = '';

  Future<void> loadExercises() async {
    emit(ExerciseLoading());
    try {
      final exercises = await _usecase.all();
      emit(ExerciseLoaded(
        exercises: exercises,
        filtered: exercises,
        selectedMuscleGroup: 'All',
      ));
    } catch (e) {
      emit(ExerciseError(e.toString()));
    }
  }

  void filterByMuscleGroup(String muscleGroup) {
    final current = state;
    if (current is! ExerciseLoaded) return;

    _selectedMuscleGroup = muscleGroup;
    _applyFilters(current.exercises);
  }

  void search(String query) {
    final current = state;
    if (current is! ExerciseLoaded) return;

    _searchQuery = query;
    _applyFilters(current.exercises);
  }

  void _applyFilters(List<Exercise> allExercises) {
    var filtered = allExercises;

    if (_selectedMuscleGroup != 'All') {
      filtered = filtered
          .where((e) => e.muscleGroup == _selectedMuscleGroup)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where((e) =>
      e.name.toLowerCase().contains(q) ||
          e.muscleGroup.toLowerCase().contains(q))
          .toList();
    }

    emit(ExerciseLoaded(
      exercises: allExercises,
      filtered: filtered,
      selectedMuscleGroup: _selectedMuscleGroup,
    ));
  }
}