import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MuscleGroupFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const MuscleGroupFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _groups = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Cardio',
  ];

  static Color _colorForGroup(String group) {
    switch (group) {
      case 'Chest':
        return AppColors.chest;
      case 'Back':
        return AppColors.back;
      case 'Legs':
        return AppColors.legs;
      case 'Shoulders':
        return AppColors.shoulders;
      case 'Arms':
        return AppColors.arms;
      case 'Core':
        return AppColors.core;
      case 'Cardio':
        return AppColors.cardio;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _groups.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final group = _groups[i];
          final isSelected = group == selected;
          final color = _colorForGroup(group);

          return GestureDetector(
            onTap: () => onSelected(group),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : AppColors.divider,
                ),
              ),
              child: Text(
                group,
                style: TextStyle(
                  color: isSelected ? AppColors.background : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}