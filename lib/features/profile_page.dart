import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_colors.dart';
import '../core/animations_helper/app_animation.dart';
import '../core/theme/cubit/theme_cubit.dart';
import 'work_progress/presentation/cubits/progress_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final cardColor = theme.cardTheme.color ?? AppColors.cardColor;
    final dividerColor = theme.dividerTheme.color ?? AppColors.divider;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          double totalSessions = 0;
          double totalVolume = 0;

          if (state is ProgressLoaded) {
            totalSessions = state.stats['total_sessions'] ?? 0;
            totalVolume = state.stats['total_volume'] ?? 0;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Avatar section ─────────────────────────────────
              AnimatedListItem(
                index: 0,
                child: Center(
                  child: Column(
                    children: [
                      FloatingWidget(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.colorScheme.primary, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/قطه.jpg',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => 
                                  Icon(Iconsax.user, size: 40, color: theme.colorScheme.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mohamed Nasr Eldeen',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Flutter Developer 💪',
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Appearance ─────────────────────────────────────
              AnimatedListItem(
                index: 1,
                child: _sectionLabel('Appearance', textSecondary),
              ),
              const SizedBox(height: 10),
              AnimatedListItem(
                index: 2,
                child: _ThemeToggleTile(
                  isDark: isDark,
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // ── About ──────────────────────────────────────────
              AnimatedListItem(
                index: 3,
                child: _sectionLabel('About', textSecondary),
              ),
              const SizedBox(height: 10),
              AnimatedListItem(
                index: 4,
                child: _settingsTile(
                  icon: Iconsax.info_circle,
                  label: 'Version',
                  trailing: Text('1.0.0',
                      style: TextStyle(color: textSecondary, fontSize: 14)),
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  textPrimary: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedListItem(
                index: 5,
                child: _settingsTile(
                  icon: Iconsax.code,
                  label: 'Built with Flutter',
                  trailing: const Text('💙', style: TextStyle(fontSize: 18)),
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  textPrimary: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedListItem(
                index: 6,
                child: _settingsTile(
                  icon: Iconsax.data,
                  label: 'Storage',
                  trailing: Text('Local SQLite',
                      style: TextStyle(color: textSecondary, fontSize: 14)),
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  textPrimary: textPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // ── Stats summary ──────────────────────────────────
              AnimatedListItem(
                index: 7,
                child: _sectionLabel('Quick Stats', textSecondary),
              ),
              const SizedBox(height: 10),
              AnimatedListItem(
                index: 8,
                child: _StatsRow(
                  sessions: totalSessions,
                  volume: totalVolume,
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String label,
    required Widget trailing,
    required Color cardColor,
    required Color dividerColor,
    required Color textPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ThemeToggleTile extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color dividerColor;
  final Color textPrimary;
  final Color textSecondary;

  const _ThemeToggleTile({
    required this.isDark,
    required this.cardColor,
    required this.dividerColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ThemeCubit>().toggleTheme(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.primary.withOpacity(0.4) : dividerColor,
          ),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Icon(
                isDark ? Iconsax.moon : Iconsax.sun_1,
                key: ValueKey(isDark),
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      isDark ? 'Dark Mode' : 'Light Mode',
                      key: ValueKey(isDark),
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDark ? 'Tap to switch to light' : 'Tap to switch to dark',
                    style: TextStyle(color: textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            _AnimatedToggle(isOn: isDark),
          ],
        ),
      ),
    );
  }
}

class _AnimatedToggle extends StatelessWidget {
  final bool isOn;
  const _AnimatedToggle({required this.isOn});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 52,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isOn ? AppColors.primary : const Color(0xFFBDBDBD),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.all(3),
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final double sessions;
  final double volume;
  final Color cardColor;
  final Color dividerColor;
  final Color textPrimary;
  final Color textSecondary;

  const _StatsRow({
    required this.sessions,
    required this.volume,
    required this.cardColor,
    required this.dividerColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _miniStat('🔥', 0, 'Day Streak', cardColor, dividerColor, textPrimary, textSecondary),
        const SizedBox(width: 10),
        _miniStat('💪', sessions, 'Workouts', cardColor, dividerColor, textPrimary, textSecondary),
        const SizedBox(width: 10),
        _miniStat('⚖️', volume, 'Volume', cardColor, dividerColor, textPrimary, textSecondary, suffix: ' kg'),
      ],
    );
  }

  Widget _miniStat(
    String emoji,
    double value,
    String label,
    Color cardColor,
    Color dividerColor,
    Color textPrimary,
    Color textSecondary, {
    String suffix = '',
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dividerColor),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            AnimatedCounter(
              value: value,
              suffix: suffix,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(label,
                style: TextStyle(color: textSecondary, fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
