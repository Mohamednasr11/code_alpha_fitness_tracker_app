import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/animations_helper/app_animation.dart';
import '../../domain/entities/models/exercise_progress.dart';
import '../cubits/progress_cubit.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _chartMode = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProgressCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }
          if (state is ProgressError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.error)));
          }
          if (state is ProgressLoaded) {
            if (state.trackedExercises.isEmpty) {
              return _buildEmpty(textPrimary, textSecondary);
            }
            return _buildContent(context, state, theme, primaryColor, textPrimary, textSecondary);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmpty(Color textPrimary, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedListItem(
            index: 0,
            child: Icon(Iconsax.chart, size: 64, color: textSecondary.withOpacity(0.5)),
          ),
          const SizedBox(height: 16),
          AnimatedListItem(
            index: 1,
            child: Text('No data yet',
                style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          AnimatedListItem(
            index: 2,
            child: Text('Log some workouts to see your progress here',
                style: TextStyle(color: textSecondary),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProgressLoaded state, ThemeData theme, Color primaryColor, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall stats
        AnimatedListItem(
          index: 0,
          child: _buildStatsGrid(state.stats, theme, primaryColor, textSecondary),
        ),
        const SizedBox(height: 24),

        // Exercise selector
        AnimatedListItem(
          index: 1,
          child: _buildExerciseSelector(context, state, textPrimary, textSecondary, primaryColor, theme),
        ),
        const SizedBox(height: 16),

        // Chart mode toggle
        if (state.selectedProgress != null &&
            state.selectedProgress!.entries.length > 1) ...[
          AnimatedListItem(
            index: 2,
            child: _buildChartModeToggle(primaryColor, textSecondary, theme),
          ),
          const SizedBox(height: 12),
          AnimatedListItem(
            index: 3,
            child: _buildChart(state.selectedProgress!, theme, primaryColor, textSecondary),
          ),
          const SizedBox(height: 24),
          AnimatedListItem(
            index: 4,
            child: _buildPRCard(state.selectedProgress!, theme, primaryColor, textPrimary, textSecondary),
          ),
        ] else if (state.selectedProgress != null) ...[
          AnimatedListItem(
            index: 2,
            child: _buildSingleEntryNote(
                state.selectedExercise ?? 'this exercise',
                textSecondary,
                theme),
          ),
        ],
      ],
    );
  }

  Widget _buildStatsGrid(Map<String, double> stats, ThemeData theme, Color primaryColor, Color textSecondary) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _statCard(Iconsax.activity, stats['total_sessions'] ?? 0, 'Sessions', primaryColor, theme, textSecondary),
        _statCard(Iconsax.repeat, stats['total_sets'] ?? 0, 'Total Sets', AppColors.arms, theme, textSecondary),
        _statCard(Iconsax.weight, stats['total_volume'] ?? 0, 'Total Volume', AppColors.legs, theme, textSecondary, suffix: ' kg'),
        _statCard(Iconsax.book_1, stats['unique_exercises'] ?? 0, 'Exercises', AppColors.chest, theme, textSecondary),
      ],
    );
  }

  Widget _statCard(IconData icon, double value, String label, Color color, ThemeData theme, Color textSecondary, {String suffix = ''}) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCounter(
                value: value,
                suffix: suffix,
                style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(label, style: TextStyle(color: textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSelector(BuildContext context, ProgressLoaded state, Color textPrimary, Color textSecondary, Color primaryColor, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exercise Progress',
            style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.trackedExercises.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final name = state.trackedExercises[i];
              final isSelected = name == state.selectedExercise;
              return GestureDetector(
                onTap: () => context.read<ProgressCubit>().selectExercise(name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : (theme.dividerTheme.color ?? Colors.grey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? primaryColor : (theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2))),
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartModeToggle(Color primaryColor, Color textSecondary, ThemeData theme) {
    return Row(
      children: [
        _toggleBtn('Max Weight', 0, primaryColor, textSecondary, theme),
        const SizedBox(width: 8),
        _toggleBtn('Volume', 1, primaryColor, textSecondary, theme),
      ],
    );
  }

  Widget _toggleBtn(String label, int mode, Color primaryColor, Color textSecondary, ThemeData theme) {
    final isSelected = _chartMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _chartMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? primaryColor : (theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2))),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(ExerciseProgress progress, ThemeData theme, Color primaryColor, Color textSecondary) {
    final spots = progress.entries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), _chartMode == 0 ? e.value.maxWeight : e.value.totalVolume);
    }).toList();

    final maxY = spots.isEmpty ? 0.0 : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.1), strokeWidth: 1)),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, _) => Text(value.toStringAsFixed(0), style: TextStyle(color: textSecondary.withOpacity(0.5), fontSize: 10)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
              final idx = value.toInt();
              if (idx < 0 || idx >= progress.entries.length) return const SizedBox();
              final date = progress.entries[idx].date;
              return Text('${date.day}/${date.month}', style: TextStyle(color: textSecondary.withOpacity(0.5), fontSize: 10));
            })),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: maxY == 0 ? 10 : maxY * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: primaryColor,
              barWidth: 3,
              dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: primaryColor, strokeWidth: 2, strokeColor: theme.cardTheme.color ?? Colors.white)),
              belowBarData: BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [primaryColor.withOpacity(0.3), primaryColor.withOpacity(0.0)])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPRCard(ExerciseProgress progress, ThemeData theme, Color primaryColor, Color textPrimary, Color textSecondary) {
    final maxWeight = progress.entries.isEmpty ? 0.0 : progress.entries.map((e) => e.maxWeight).reduce((a, b) => a > b ? a : b);
    final maxVolume = progress.entries.isEmpty ? 0.0 : progress.entries.map((e) => e.totalVolume).reduce((a, b) => a > b ? a : b);
    final totalReps = progress.entries.isEmpty ? 0 : progress.entries.map((e) => e.totalReps).reduce((a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Records', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            children: [
              _prItem('🏆', 'Best Weight', maxWeight, primaryColor, textSecondary, suffix: ' kg'),
              _prItem('🔥', 'Best Session', maxVolume, primaryColor, textSecondary, suffix: ' kg'),
              _prItem('💪', 'Total Reps', totalReps.toDouble(), primaryColor, textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prItem(String emoji, String label, double value, Color primaryColor, Color textSecondary, {String suffix = ''}) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          AnimatedCounter(
            value: value,
            suffix: suffix,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(label, style: TextStyle(color: textSecondary, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSingleEntryNote(
      String exerciseName, Color textSecondary, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: (theme.dividerTheme.color ?? Colors.grey).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Iconsax.info_circle, color: textSecondary, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
                  'Log "$exerciseName" in at least 2 sessions to see a progress chart.',
                  style: TextStyle(color: textSecondary, fontSize: 13))),
        ],
      ),
    );
  }
}
