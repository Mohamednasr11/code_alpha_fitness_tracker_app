import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/workout_set.dart';

class SetTile extends StatelessWidget {
  final WorkoutSet set;
  const SetTile({super.key, required this.set});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${set.setNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              '${set.reps} reps',
              textAlign: TextAlign.left,
              style:
              const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
          ),

          Expanded(
            child: Text(
              '${set.weight} kg',
              textAlign: TextAlign.right,
              style:
              const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}