import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/usecases/generated_workout_usecase.dart';
import '../../domain/generated_workout.dart';

part 'generator_state.dart';

class GeneratorCubit extends Cubit<GeneratorState> {
  final GenerateWorkoutUsecase _usecase;

  GeneratorCubit(this._usecase) : super(GeneratorInitial());

  void generate(GeneratorInput input) {
    emit(GeneratorLoading());
    try {
      final days = _usecase(input);
      emit(GeneratorLoaded(days: days, input: input));
    } catch (e) {
      emit(GeneratorError(e.toString()));
    }
  }

  void reset() => emit(GeneratorInitial());
}
