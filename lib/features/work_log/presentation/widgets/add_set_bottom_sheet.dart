import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../exercise_library/domain/entities/exercise.dart';
import '../../../exercise_library/presentation/cubit/exercise_cubit.dart';
import '../../domain/entities/workout_session.dart';

class AddSetBottomSheet extends StatefulWidget {
  final WorkoutSession session;
  final Function({
  required Exercise exercise,
  required int reps,
  required double weight,
  }) onAddSet;

  const AddSetBottomSheet({
    super.key,
    required this.session,
    required this.onAddSet,
  });

  @override
  State<AddSetBottomSheet> createState() => _AddSetBottomSheetState();
}

class _AddSetBottomSheetState extends State<AddSetBottomSheet> {
  Exercise? _selectedExercise;
  final _repsController = TextEditingController(text: '10');
  final _weightController = TextEditingController(text: '0');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExerciseCubit>()..loadExercises(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Log Set',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Exercise dropdown
              BlocBuilder<ExerciseCubit, ExerciseState>(
                builder: (context, state) {
                  final exercises =
                  state is ExerciseLoaded ? state.exercises : <Exercise>[];
                  return DropdownButtonFormField<Exercise>(
                    value: _selectedExercise,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Select exercise',
                      prefixIcon: Icon(Iconsax.weight,
                          color: AppColors.textHint, size: 20),
                    ),
                    items: exercises
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text('${e.name} (${e.muscleGroup})',
                          style: const TextStyle(fontSize: 14)),
                    ))
                        .toList(),
                    onChanged: (e) => setState(() => _selectedExercise = e),
                    validator: (v) =>
                    v == null ? 'Select an exercise' : null,
                  );
                },
              ),
              const SizedBox(height: 12),

              // Reps & Weight row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      style:
                      const TextStyle(color: AppColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Reps',
                        prefixIcon: Icon(Iconsax.repeat,
                            color: AppColors.textHint, size: 20),
                      ),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n <= 0) return 'Enter valid reps';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      style:
                      const TextStyle(color: AppColors.textPrimary),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        prefixIcon: Icon(Iconsax.weight_1,
                            color: AppColors.textHint, size: 20),
                      ),
                      validator: (v) {
                        final n = double.tryParse(v ?? '');
                        if (n == null || n < 0) return 'Enter valid weight';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onAddSet(
                      exercise: _selectedExercise!,
                      reps: int.parse(_repsController.text),
                      weight: double.parse(_weightController.text),
                    );
                  }
                },
                child: const Text('Add Set'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}