import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/di/service_locator.dart';
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
    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final dividerColor = theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2);

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
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Log Set',
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              BlocBuilder<ExerciseCubit, ExerciseState>(
                builder: (context, state) {
                  final exercises = state is ExerciseLoaded ? state.exercises : <Exercise>[];
                  return DropdownButtonFormField<Exercise>(
                    initialValue: _selectedExercise,
                    dropdownColor: theme.cardTheme.color,
                    style: TextStyle(color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Select exercise',
                      hintStyle: TextStyle(color: theme.hintColor),
                      prefixIcon: Icon(Iconsax.weight, color: theme.hintColor, size: 20),
                    ),
                    items: exercises.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text('${e.name} (${e.muscleGroup})', style: const TextStyle(fontSize: 14)),
                    )).toList(),
                    onChanged: (e) => setState(() => _selectedExercise = e),
                    validator: (v) => v == null ? 'Select an exercise' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      style: TextStyle(color: textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Reps',
                        labelStyle: TextStyle(color: theme.hintColor),
                        prefixIcon: Icon(Iconsax.repeat, color: theme.hintColor, size: 20),
                      ),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n <= 0) return 'Required';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      style: TextStyle(color: textPrimary),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        labelStyle: TextStyle(color: theme.hintColor),
                        prefixIcon: Icon(Iconsax.weight_1, color: theme.hintColor, size: 20),
                      ),
                      validator: (v) {
                        final n = double.tryParse(v ?? '');
                        if (n == null || n < 0) return 'Required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
