import 'package:fitness_tracker/core/utils/get_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/routing/app_routing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/animations_helper/app_animation.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubits/workout_cubit.dart';
import '../widgets/new_session_bottom_sheet.dart';
import '../widgets/session_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        toolbarHeight: 100,
        leadingWidth: 0,
        titleSpacing: 16,
        title: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccessState) {
              final displayName = AppHelpers.getDisplayName(state.user.email);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    'Welcome',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.disabledColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }
            return const Text('');
          },
        ),
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
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkoutError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.error)));
          }
          if (state is WorkoutLoaded) {
            if (state.sessions.isEmpty) {
              return _buildEmpty(context, textSecondary);
            }
            return _buildSessionList(context, state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewSessionSheet(context),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Iconsax.add),
        label: const Text('New Workout',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedListItem(
            index: 0,
            child: Icon(Iconsax.weight,
                size: 64, color: textSecondary.withValues(alpha: .5)),
          ),
          const SizedBox(height: 16),
          const AnimatedListItem(
            index: 1,
            child: Text('No workouts yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          AnimatedListItem(
            index: 2,
            child: Text('Tap the button below to start your first session',
                style: TextStyle(color: textSecondary),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 24),
          AnimatedListItem(
            index: 3,
            child: SizedBox(
              width: 320,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _showNewSessionSheet(context),
                icon: const Icon(Iconsax.add),
                label: const Text('Start Workout'),
              ),
            ),
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
        return AnimatedListItem(
          index: i,
          child: SessionCard(
            session: session,
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.workoutDetail,
              arguments: session,
            ),
            onDelete: () =>
                context.read<WorkoutCubit>().removeSession(session.id!),
          ),
        );
      },
    );
  }

  void _showNewSessionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
