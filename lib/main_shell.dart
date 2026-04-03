import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_colors.dart';
import 'features/work_generator/presentation/cubits/generator_cubit.dart';
import 'features/work_generator/presentation/pages/workout_generator_page.dart';
import 'features/work_log/presentation/cubits/workout_cubit.dart';
import 'features/work_log/presentation/pages/home_page.dart';
import 'features/work_progress/presentation/cubits/progress_cubit.dart';
import 'features/work_progress/presentation/pages/progress_page.dart';


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
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WorkoutCubit>()..loadSessions()),
        BlocProvider(create: (_) => sl<ProgressCubit>()),
        BlocProvider(create: (_) => sl<GeneratorCubit>()),
      ],
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
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
        ],
      ),
    );
  }
}