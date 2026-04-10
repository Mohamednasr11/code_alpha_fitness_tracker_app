import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/generated_workout.dart';
import '../cubits/generator_cubit.dart';
import '../../../../core/animations_helper/app_animation.dart';

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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

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
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }
          if (state is GeneratorLoaded) {
            return _buildResult(state, theme, primaryColor, textPrimary, textSecondary);
          }
          return _buildForm(context, theme, primaryColor, textPrimary, textSecondary);
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, ThemeData theme, Color primaryColor, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AnimatedListItem(
          index: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Build Your Plan',
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Answer 3 questions and get a personalized plan',
                  style: TextStyle(color: textSecondary, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Goal
        AnimatedListItem(
          index: 1,
          child: _sectionLabel('🎯 What\'s your goal?', textPrimary),
        ),
        const SizedBox(height: 10),
        AnimatedListItem(
          index: 2,
          child: _optionGrid<FitnessGoal>(
            options: {
              FitnessGoal.buildMuscle: ('💪', 'Build Muscle'),
              FitnessGoal.loseWeight: ('🔥', 'Lose Weight'),
              FitnessGoal.improveEndurance: ('🏃', 'Endurance'),
              FitnessGoal.maintainFitness: ('⚖️', 'Maintain'),
            },
            selected: _goal,
            onSelect: (v) => setState(() => _goal = v),
            primaryColor: primaryColor,
            theme: theme,
          ),
        ),
        const SizedBox(height: 24),

        // Level
        AnimatedListItem(
          index: 3,
          child: _sectionLabel('📊 Your fitness level?', textPrimary),
        ),
        const SizedBox(height: 10),
        AnimatedListItem(
          index: 4,
          child: _optionGrid<FitnessLevel>(
            options: {
              FitnessLevel.beginner: ('🌱', 'Beginner'),
              FitnessLevel.intermediate: ('⚡', 'Intermediate'),
              FitnessLevel.advanced: ('🚀', 'Advanced'),
            },
            selected: _level,
            onSelect: (v) => setState(() => _level = v),
            primaryColor: primaryColor,
            theme: theme,
          ),
        ),
        const SizedBox(height: 24),

        // Days
        AnimatedListItem(
          index: 5,
          child: _sectionLabel('📅 Days per week?', textPrimary),
        ),
        const SizedBox(height: 10),
        AnimatedListItem(
          index: 6,
          child: _optionGrid<WorkoutDays>(
            options: {
              WorkoutDays.three: ('3️⃣', '3 Days'),
              WorkoutDays.four: ('4️⃣', '4 Days'),
              WorkoutDays.five: ('5️⃣', '5 Days'),
            },
            selected: _days,
            onSelect: (v) => setState(() => _days = v),
            primaryColor: primaryColor,
            theme: theme,
          ),
        ),
        const SizedBox(height: 32),

        AnimatedListItem(
          index: 7,
          child: ElevatedButton.icon(
            onPressed: () => context.read<GeneratorCubit>().generate(
                  GeneratorInput(goal: _goal, level: _level, daysPerWeek: _days),
                ),
            icon: const Icon(Iconsax.magic_star),
            label: const Text('Generate Plan'),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w600));
  }

  Widget _optionGrid<T>({
    required Map<T, (String, String)> options,
    required T selected,
    required ValueChanged<T> onSelect,
    required Color primaryColor,
    required ThemeData theme,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withOpacity(0.12)
                  : theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryColor : (theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2)),
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
                      color: isSelected ? primaryColor : theme.textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResult(GeneratorLoaded state, ThemeData theme, Color primaryColor, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AnimatedListItem(
          index: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.2),
                  primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Iconsax.magic_star, color: primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _goalLabel(state.input.goal),
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        '${_levelLabel(state.input.level)} · ${state.days.length} days/week',
                        style: TextStyle(color: textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...state.days.asMap().entries.map((e) => AnimatedListItem(
          index: e.key + 1,
          child: _buildDayCard(e.value, theme, primaryColor, textPrimary, textSecondary),
        )),
      ],
    );
  }

  Widget _buildDayCard(GeneratedWorkoutDay day, ThemeData theme, Color primaryColor, Color textPrimary, Color textSecondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        collapsedIconColor: textSecondary.withOpacity(0.5),
        iconColor: primaryColor,
        title: Row(
          children: [
            Text(day.dayName,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(width: 8),
            Text('· ${day.focus}',
                style: TextStyle(color: textSecondary, fontSize: 13)),
          ],
        ),
        subtitle: Text(
          '${day.exercises.length} exercises',
          style: TextStyle(color: textSecondary.withOpacity(0.7), fontSize: 12),
        ),
        children: day.exercises.map((ex) => _buildExerciseTile(ex, theme, primaryColor, textPrimary, textSecondary)).toList(),
      ),
    );
  }

  Widget _buildExerciseTile(GeneratedExercise ex, ThemeData theme, Color primaryColor, Color textPrimary, Color textSecondary) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (theme.dividerTheme.color ?? Colors.grey).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex.name,
                    style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(ex.muscleGroup,
                    style: TextStyle(color: textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${ex.sets} sets × ${ex.reps}',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text('Rest ${ex.rest}',
                  style: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 11)),
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
