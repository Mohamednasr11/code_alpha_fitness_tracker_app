import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/exercise_cubit.dart';
import '../widgets/exercise_card.dart';
import '../widgets/muscle_group_filter.dart';

class ExerciseLibraryPage extends StatelessWidget {
  const ExerciseLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExerciseCubit>()..loadExercises(),
      child: const _ExerciseLibraryView(),
    );
  }
}

class _ExerciseLibraryView extends StatefulWidget {
  const _ExerciseLibraryView();

  @override
  State<_ExerciseLibraryView> createState() => _ExerciseLibraryViewState();
}

class _ExerciseLibraryViewState extends State<_ExerciseLibraryView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (q) =>
                  context.read<ExerciseCubit>().search(q),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Iconsax.search_normal,
                    color: AppColors.textHint, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Iconsax.close_circle,
                      color: AppColors.textHint, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ExerciseCubit>().search('');
                  },
                )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Muscle group filter chips
          BlocBuilder<ExerciseCubit, ExerciseState>(
            builder: (context, state) {
              if (state is! ExerciseLoaded) return const SizedBox();
              return MuscleGroupFilter(
                selected: state.selectedMuscleGroup,
                onSelected: (group) =>
                    context.read<ExerciseCubit>().filterByMuscleGroup(group),
              );
            },
          ),

          const SizedBox(height: 8),

          // Exercise list
          Expanded(
            child: BlocBuilder<ExerciseCubit, ExerciseState>(
              builder: (context, state) {
                if (state is ExerciseLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary));
                }
                if (state is ExerciseError) {
                  return Center(
                      child: Text(state.message,
                          style: const TextStyle(
                              color: AppColors.error)));
                }
                if (state is ExerciseLoaded) {
                  if (state.filtered.isEmpty) {
                    return const Center(
                      child: Text('No exercises found',
                          style:
                          TextStyle(color: AppColors.textSecondary)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: state.filtered.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (_, i) =>
                        ExerciseCard(exercise: state.filtered[i]),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}