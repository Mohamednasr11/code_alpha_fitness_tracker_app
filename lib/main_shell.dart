import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'core/theme/app_colors.dart';
import 'features/work_generator/presentation/pages/workout_generator_page.dart';
import 'features/work_log/presentation/pages/home_page.dart';
import 'features/work_progress/presentation/pages/progress_page.dart';
import 'features/profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProgressPage(),
    WorkoutGeneratorPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerTheme.color ?? AppColors.divider;

    return Scaffold(
      body: PageTransitionSwitcher(
        index: _currentIndex,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: dividerColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              activeIcon: Icon(Iconsax.home_15),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.chart),
              activeIcon: Icon(Iconsax.chart_15),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.magic_star),
              activeIcon: Icon(Iconsax.magic_star5),
              label: 'Generate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user),
              activeIcon: Icon(Iconsax.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class PageTransitionSwitcher extends StatelessWidget {
  final int index;
  final Widget child;

  const PageTransitionSwitcher({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.02, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<int>(index),
        child: child,
      ),
    );
  }
}
