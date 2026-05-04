import 'package:flutter/material.dart';
import '../../../core/routing/app_routing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();// اول لما التطبيق يتفتح اي الي يحصل ؟
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0.8, end: 1.2),
        // معناها اكبر من 80% حجم الي 120 % حجم زي ما بنكبر الشاشه من 80 الي 120
        curve: Curves.easeInOutCubicEmphasized,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            ); // دي الي بتنفذ التكبير
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fitness_center_rounded,
                size: 100,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'FITNESS TRACKER',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
