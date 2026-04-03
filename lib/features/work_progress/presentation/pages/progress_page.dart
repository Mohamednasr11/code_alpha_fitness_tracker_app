import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/models/exercise_progress.dart';
import '../cubits/progress_cubit.dart';


class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // 0 = max weight, 1 = volume
  int _chartMode = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProgressCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is ProgressError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.error)));
          }
          if (state is ProgressLoaded) {
            if (state.trackedExercises.isEmpty) {
              return _buildEmpty();
            }
            return _buildContent(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.chart, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text('No data yet',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Log some workouts to see your progress here',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProgressLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall stats
        _buildStatsGrid(state.stats),
        const SizedBox(height: 24),

        // Exercise selector
        _buildExerciseSelector(context, state),
        const SizedBox(height: 16),

        // Chart mode toggle
        if (state.selectedProgress != null &&
            state.selectedProgress!.entries.length > 1) ...[
          _buildChartModeToggle(),
          const SizedBox(height: 12),
          _buildChart(state.selectedProgress!),
          const SizedBox(height: 24),
          _buildPRCard(state.selectedProgress!),
        ] else if (state.selectedProgress != null) ...[
          _buildSingleEntryNote(),
        ],
      ],
    );
  }

  Widget _buildStatsGrid(Map<String, double> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _statCard(
          Iconsax.activity,
          '${stats['total_sessions']?.toInt() ?? 0}',
          'Sessions',
          AppColors.primary,
        ),
        _statCard(
          Iconsax.repeat,
          '${stats['total_sets']?.toInt() ?? 0}',
          'Total Sets',
          AppColors.arms,
        ),
        _statCard(
          Iconsax.weight,
          '${(stats['total_volume'] ?? 0).toStringAsFixed(0)} kg',
          'Total Volume',
          AppColors.legs,
        ),
        _statCard(
          Iconsax.book_1,
          '${stats['unique_exercises']?.toInt() ?? 0}',
          'Exercises',
          AppColors.chest,
        ),
      ],
    );
  }

  Widget _statCard(
      IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSelector(
      BuildContext context, ProgressLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Exercise Progress',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
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
                onTap: () =>
                    context.read<ProgressCubit>().selectExercise(name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  Widget _buildChartModeToggle() {
    return Row(
      children: [
        _toggleBtn('Max Weight', 0),
        const SizedBox(width: 8),
        _toggleBtn('Volume', 1),
      ],
    );
  }

  Widget _toggleBtn(String label, int mode) {
    final isSelected = _chartMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _chartMode = mode),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
            isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(ExerciseProgress progress) {
    final spots = progress.entries.asMap().entries.map((e) {
      final value = _chartMode == 0
          ? e.value.maxWeight
          : e.value.totalVolume;
      return FlSpot(e.key.toDouble(), value);
    }).toList();

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= progress.entries.length) {
                    return const SizedBox();
                  }
                  final date = progress.entries[idx].date;
                  return Text(
                    '${date.day}/${date.month}',
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: maxY * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: AppColors.background,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                _chartMode == 0
                    ? '${s.y.toStringAsFixed(1)} kg'
                    : '${s.y.toStringAsFixed(0)} kg vol',
                const TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPRCard(ExerciseProgress progress) {
    final maxWeight = progress.entries
        .map((e) => e.maxWeight)
        .reduce((a, b) => a > b ? a : b);
    final maxVolume = progress.entries
        .map((e) => e.totalVolume)
        .reduce((a, b) => a > b ? a : b);
    final totalReps = progress.entries
        .map((e) => e.totalReps)
        .reduce((a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Records',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              _prItem('🏆', 'Best Weight', '${maxWeight.toStringAsFixed(1)} kg'),
              _prItem('🔥', 'Best Session', '${maxVolume.toStringAsFixed(0)} kg'),
              _prItem('💪', 'Total Reps', '$totalReps'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prItem(String emoji, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSingleEntryNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Iconsax.info_circle, color: AppColors.textSecondary, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Log this exercise in at least 2 sessions to see a progress chart.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}