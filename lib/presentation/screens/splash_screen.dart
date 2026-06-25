import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/profile_provider.dart';
import 'onboarding_screen.dart';
import 'auth_screen.dart';
import 'home_dashboard.dart';
import 'lock_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      UserProfile? profile = ref.read(profileProvider);
      int retries = 0;
      while (profile == null && retries < 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        profile = ref.read(profileProvider);
        retries++;
      }
      
      final authState = ref.read(authProvider);
      Widget targetScreen;

      if (authState.isLoggedIn) {
        if (profile?.appPasscode != null && profile!.appPasscode!.isNotEmpty) {
          targetScreen = const LockScreen();
        } else {
          targetScreen = const HomeDashboard();
        }
      } else {
        if (authState.tradingType != null && authState.tradingType!.isNotEmpty) {
          targetScreen = const AuthScreen();
        } else {
          targetScreen = const OnboardingScreen();
        }
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force initialization of providers at startup so they are fully loaded by the time the timer fires
    ref.watch(authProvider);
    ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.auto_graph_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'TradeOS',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                letterSpacing: 2.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
