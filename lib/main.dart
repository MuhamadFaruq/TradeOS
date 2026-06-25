import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/services/isar_service.dart';
import 'presentation/screens/splash_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'core/services/notification_service.dart';
import 'core/services/economic_calendar_service.dart';
import 'data/models/economic_event.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize services in background isolate
      await NotificationService.init();
      await IsarService.init();

      final events = await EconomicCalendarService().fetchEvents();
      final highImpact = events.where((e) => e.impact == Impact.high).toList();

      if (highImpact.isNotEmpty) {
        await NotificationService.showNotification(
          id: 0,
          title: 'High Impact News Today',
          body: 'Faruq, there are ${highImpact.length} major news events today. Stay sharp!',
        );
      }
      return true;
    } catch (e) {
      print('Background task error: $e');
      return false;
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Background Services
  await NotificationService.init();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    'daily-news-check',
    'fetchEconomicNews',
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(minutes: 5),
  );
  
  // Show a premium loading screen immediately while Isar initializes
  runApp(const InitialLoadingApp());
  
  try {
    await IsarService.init();
    
    runApp(
      const ProviderScope(
        child: TradeOSApp(),
      ),
    );
  } catch (e) {
    // Handle initialization error (e.g., show an error UI)
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Initialization Error: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
    ));
  }
}

class InitialLoadingApp extends StatelessWidget {
  const InitialLoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                'INITIALIZING DATABASE',
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.7),
                  letterSpacing: 2.0,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TradeOSApp extends StatelessWidget {
  const TradeOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
