import 'package:flutter/material.dart';
import '../../domain/entities/workout_set.dart';

class SetTile extends StatelessWidget {
  final WorkoutSet set;
  final int index; // أضفت الـ index للتحكم بتوقيت الحركة (Staggered Animation)

  const SetTile({
    super.key,
    required this.set,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // TweenAnimationBuilder لإضافة حركة دخول (Fade + Slide)
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)), // تأخير بسيط لكل عنصر
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // استخدام الـ Theme بدلاً من الألوان الثابتة
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // رقم الجلسة بتصميم مميز
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${set.setNumber}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // التكرارات (Reps)
            Expanded(
              flex: 2,
              child: Text(
                '${set.reps} reps',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // الوزن (Weight)
            Expanded(
              flex: 2,
              child: Text(
                '${set.weight} kg',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}