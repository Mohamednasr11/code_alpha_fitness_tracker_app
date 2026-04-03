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
              ? _buildEmpty(context, current)
              : _buildSetList(context, current, grouped),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddSetSheet(context, current),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            icon: const Icon(Iconsax.add),
            label: const Text('Add Set',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context, WorkoutSession session) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.activity, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text('No sets logged yet',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap "Add Set" to log your first exercise',
              style: TextStyle(color: AppColors.textSecondary)),
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
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Session stats header
        _buildStatsRow(session),
        const SizedBox(height: 20),

        // Sets grouped by exercise
        ...grouped.entries.map((entry) {
          final sets = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Header row
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    SizedBox(
                        width: 40,
                        child: Text('SET',
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 11))),
                    Expanded(
                        child: Text('REPS',
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 11))),
                    Expanded(
                        child: Text('WEIGHT (kg)',
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 11))),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ...sets.map((s) => SetTile(set: s)),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatsRow(WorkoutSession session) {
    final totalVolume =
        session.sets.fold<double>(0, (sum, s) => sum + (s.reps * s.weight));
    final exercises = session.sets.map((s) => s.exercise.name).toSet().length;

    return Row(
      children: [
        _statChip(Iconsax.activity, '${session.sets.length}', 'Sets'),
        const SizedBox(width: 12),
        _statChip(Iconsax.weight, '$exercises', 'Exercises'),
        const SizedBox(width: 12),
        _statChip(
            Iconsax.chart_21, '${totalVolume.toStringAsFixed(0)} kg', 'Volume'),
      ],
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showAddSetSheet(BuildContext context, WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
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
