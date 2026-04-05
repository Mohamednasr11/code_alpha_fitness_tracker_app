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

  static Color _colorForGroup(String group, Color primary) {
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
        return primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? Colors.white;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final dividerColor = theme.dividerTheme.color ?? Colors.grey.withOpacity(0.2);
    final primaryColor = theme.colorScheme.primary;

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
          final color = _colorForGroup(group, primaryColor);

          return GestureDetector(
            onTap: () => onSelected(group),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color : cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : dividerColor,
                ),
              ),
              child: Text(
                group,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : textSecondary,
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
