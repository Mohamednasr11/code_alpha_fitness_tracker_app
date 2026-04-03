import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/generated_workout.dart';
import '../cubits/generator_cubit.dart';


class WorkoutGeneratorPage extends StatefulWidget {
  const WorkoutGeneratorPage({super.key});

  @override
  State<WorkoutGeneratorPage> createState() => _WorkoutGeneratorPageState();
}

class _WorkoutGeneratorPageState extends State<WorkoutGeneratorPage> {
  FitnessGoal _goal = FitnessGoal.buildMuscle;
  FitnessLevel _level = FitnessLevel.intermediate;
  WorkoutDays _days = WorkoutDays.three;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Generator'),
        actions: [
          BlocBuilder<GeneratorCubit, GeneratorState>(
            builder: (context, state) {
              if (state is GeneratorLoaded) {
                return IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: () => context.read<GeneratorCubit>().reset(),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<GeneratorCubit, GeneratorState>(
        builder: (context, state) {
          if (state is GeneratorLoading) {
            return const Center(
                child:
                CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is GeneratorLoaded) {
            return _buildResult(state);
          }
          return _buildForm(context);
        },
      ),
    );
  }

  // ── FORM ─────────────────────────────────────────────────
  Widget _buildForm(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Build Your Plan',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Answer 3 questions and get a personalized workout plan',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 28),

        // Goal
        _sectionLabel('🎯 What\'s your goal?'),
        const SizedBox(height: 10),
        _optionGrid<FitnessGoal>(
          options: {
            FitnessGoal.buildMuscle: ('💪', 'Build Muscle'),
            FitnessGoal.loseWeight: ('🔥', 'Lose Weight'),
            FitnessGoal.improveEndurance: ('🏃', 'Endurance'),
            FitnessGoal.maintainFitness: ('⚖️', 'Maintain'),
          },
          selected: _goal,
          onSelect: (v) => setState(() => _goal = v),
        ),
        const SizedBox(height: 24),

        // Level
        _sectionLabel('📊 Your fitness level?'),
        const SizedBox(height: 10),
        _optionGrid<FitnessLevel>(
          options: {
            FitnessLevel.beginner: ('🌱', 'Beginner'),
            FitnessLevel.intermediate: ('⚡', 'Intermediate'),
            FitnessLevel.advanced: ('🚀', 'Advanced'),
          },
          selected: _level,
          onSelect: (v) => setState(() => _level = v),
        ),
        const SizedBox(height: 24),

        // Days
        _sectionLabel('📅 Days per week?'),
        const SizedBox(height: 10),
        _optionGrid<WorkoutDays>(
          options: {
            WorkoutDays.three: ('3️⃣', '3 Days'),
            WorkoutDays.four: ('4️⃣', '4 Days'),
            WorkoutDays.five: ('5️⃣', '5 Days'),
          },
          selected: _days,
          onSelect: (v) => setState(() => _days = v),
        ),
        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: () => context.read<GeneratorCubit>().generate(
            GeneratorInput(
                goal: _goal, level: _level, daysPerWeek: _days),
          ),
          icon: const Icon(Iconsax.magic_star),
          label: const Text('Generate Plan'),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text,
        style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600));
  }

  Widget _optionGrid<T>({
    required Map<T, (String, String)> options,
    required T selected,
    required ValueChanged<T> onSelect,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.entries.map((e) {
        final isSelected = e.key == selected;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.value.$1, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(e.value.$2,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── RESULT ────────────────────────────────────────────────
  Widget _buildResult(GeneratorLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.2),
                AppColors.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.magic_star, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _goalLabel(state.input.goal),
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      '${_levelLabel(state.input.level)} · ${state.days.length} days/week',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Days
        ...state.days.map((day) => _buildDayCard(day)),
      ],
    );
  }

  Widget _buildDayCard(GeneratedWorkoutDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: ExpansionTile(
        collapsedIconColor: AppColors.textHint,
        iconColor: AppColors.primary,
        title: Row(
          children: [
            Text(day.dayName,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(width: 8),
            Text('· ${day.focus}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
        subtitle: Text(
          '${day.exercises.length} exercises',
          style: const TextStyle(
              color: AppColors.textHint, fontSize: 12),
        ),
        children: day.exercises.map((ex) => _buildExerciseTile(ex)).toList(),
      ),
    );
  }

  Widget _buildExerciseTile(GeneratedExercise ex) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(ex.muscleGroup,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${ex.sets} sets × ${ex.reps}',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text('Rest ${ex.rest}',
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  String _goalLabel(FitnessGoal g) {
    switch (g) {
      case FitnessGoal.buildMuscle:
        return '💪 Build Muscle Plan';
      case FitnessGoal.loseWeight:
        return '🔥 Weight Loss Plan';
      case FitnessGoal.improveEndurance:
        return '🏃 Endurance Plan';
      case FitnessGoal.maintainFitness:
        return '⚖️ Maintenance Plan';
    }
  }

  String _levelLabel(FitnessLevel l) {
    switch (l) {
      case FitnessLevel.beginner:
        return 'Beginner';
      case FitnessLevel.intermediate:
        return 'Intermediate';
      case FitnessLevel.advanced:
        return 'Advanced';
    }
  }
}