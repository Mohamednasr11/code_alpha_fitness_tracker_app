import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/routing/app_routing.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubits/workout_cubit.dart';
import '../widgets/new_session_n=bottom_sheet.dart';
import '../widgets/session_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.book_1),
            tooltip: 'Exercise Library',
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.exerciseLibrary),
          ),
        ],
      ),
      body: BlocBuilder<WorkoutCubit, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is WorkoutError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.error)));
          }
          if (state is WorkoutLoaded) {
            if (state.sessions.isEmpty) {
              return _buildEmpty(context);
            }
            return _buildSessionList(context, state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewSessionSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        icon: const Icon(Iconsax.add),
        label: const Text('New Workout',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.weight, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text('No workouts yet',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap the button below to start your first session',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showNewSessionSheet(context),
            icon: const Icon(Iconsax.add),
            label: const Text('Start Workout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(BuildContext context, WorkoutLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: state.sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final session = state.sessions[i];
        return SessionCard(
          session: session,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouter.workoutDetail,
            arguments: session,
          ),
          onDelete: () => context.read<WorkoutCubit>().removeSession(session.id!),
        );
      },
    );
  }

  void _showNewSessionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => NewSessionBottomSheet(
        onCreateSession: (name) async {
          final session =
          await context.read<WorkoutCubit>().startNewSession(name);
          if (session != null && context.mounted) {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRouter.workoutDetail,
                arguments: session);
          }
        },
      ),
    );
  }
}