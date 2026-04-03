import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/workout_session.dart';

class SessionCard extends StatelessWidget {
  final WorkoutSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final totalVolume =
    session.sets.fold<double>(0, (sum, s) => sum + (s.reps * s.weight));
    final exercises = session.sets.map((s) => s.exercise.name).toSet();

    return Dismissible(
      key: Key('session_${session.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Iconsax.trash, color: AppColors.error),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('Delete Session',
                style: TextStyle(color: AppColors.textPrimary)),
            content: const Text('Are you sure you want to delete this workout?',
                style: TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete',
                    style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(session.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(_formatDate(session.date),
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
              if (exercises.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  exercises.take(3).join(' · ') +
                      (exercises.length > 3
                          ? ' +${exercises.length - 3} more'
                          : ''),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _infoChip(Iconsax.activity, '${session.sets.length} sets'),
                  const SizedBox(width: 12),
                  _infoChip(Iconsax.weight,
                      '${totalVolume.toStringAsFixed(0)} kg volume'),
                  const Spacer(),
                  const Icon(Iconsax.arrow_right_3,
                      color: AppColors.textHint, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}