import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/routing/app_routing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../exercise_library/domain/entities/exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../cubits/workout_cubit.dart';
import '../widgets/add_set_bottom_sheet.dart';
import '../widgets/set_title.dart';
import '../../../../core/animations_helper/app_animation.dart';

class WorkoutDetailPage extends StatelessWidget {
  final WorkoutSession? session;

  const WorkoutDetailPage({super.key, this.session});

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('Session not found')),
      );
    }

    final theme = Theme.of(context);
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return BlocBuilder<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        // Get the latest session data from state
        WorkoutSession current = session!;
        if (state is WorkoutLoaded) {
          final updated = state.sessions.where((s) => s.id == session!.id);
          if (updated.isNotEmpty) current = updated.first;
        }

        // Group sets by exercise
        final Map<String, List<dynamic>> grouped = {};
        for (final set in current.sets) {
          grouped.putIfAbsent(set.exercise.name, () => []).add(set);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(current.name),
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.book_1),
                tooltip: 'Browse exercises',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.exerciseLibrary),
              ),
            ],
          ),
          body: current.sets.isEmpty
              ? _buildEmpty(context, current, textPrimary, textSecondary)
              : _buildSetList(context, current, grouped, textPrimary, textSecondary),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddSetSheet(context, current),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: const Icon(Iconsax.add),
            label: const Text('Add Set',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context, WorkoutSession session, Color textPrimary, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.activity, size: 64, color: textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('No sets logged yet',
              style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tap "Add Set" to log your first exercise',
              style: TextStyle(color: textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddSetSheet(context, session),
            icon: const Icon(Iconsax.add),
            label: const Text('Add Set'),
          ),
        ],
      ),
    );
  }

  Widget _buildSetList(
    BuildContext context,
    WorkoutSession session,
    Map<String, List<dynamic>> grouped,
    Color textPrimary,
    Color textSecondary,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Session stats header
        _buildStatsRow(context, session),
        const SizedBox(height: 20),

        // Sets grouped by exercise
        ...grouped.entries.toList().asMap().entries.map((entry) {
          final exerciseIndex = entry.key;
          final exerciseName = entry.value.key;
          final sets = entry.value.value;
          
          return AnimatedListItem(
            index: exerciseIndex + 1, // +1 because stats row is index 0
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    exerciseName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 45,
                        child: Text(
                          'SET',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: textSecondary.withOpacity(0.5), fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Text(
                          'REPS',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: textSecondary.withOpacity(0.5), fontSize: 11),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          'WEIGHT (kg)',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: textSecondary.withOpacity(0.5), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...sets.map((s) => SetTile(set: s)),
                const SizedBox(height: 16),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, WorkoutSession session) {
    final totalVolume =
        session.sets.fold<double>(0, (sum, s) => sum + (s.reps * s.weight));
    final exercises = session.sets.map((s) => s.exercise.name).toSet().length;

    return AnimatedListItem(
      index: 0,
      child: Row(
        children: [
          _statChip(context, Iconsax.activity, session.sets.length.toDouble(), 'Sets'),
          const SizedBox(width: 12),
          _statChip(context, Iconsax.weight, exercises.toDouble(), 'Exercises'),
          const SizedBox(width: 12),
          _statChip(context, Iconsax.chart_21, totalVolume, 'Volume', isWeight: true),
        ],
      ),
    );
  }

  Widget _statChip(BuildContext context, IconData icon, double value, String label, {bool isWeight = false}) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 18),
            const SizedBox(height: 4),
            AnimatedCounter(
              value: value,
              suffix: isWeight ? ' kg' : '',
              style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            Text(label,
                style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showAddSetSheet(BuildContext context, WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddSetBottomSheet(
        session: session,
        onAddSet: ({
          required Exercise exercise,
          required int reps,
          required double weight,
        }) {
          final setNumber =
              session.sets.where((s) => s.exercise.id == exercise.id).length +
                  1;
          context.read<WorkoutCubit>().logSet(
                sessionId: session.id!,
                exercise: exercise,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
              );
          Navigator.pop(context);
        },
      ),
    );
  }
}
