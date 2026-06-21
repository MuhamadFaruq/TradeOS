import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/economic_event.dart';
import '../../core/services/economic_calendar_service.dart';

final economicCalendarServiceProvider = Provider((ref) => EconomicCalendarService());

// Auto-dispose stream provider to refresh whenever the screen is opened
final economicCalendarProvider = StreamProvider.autoDispose<List<EconomicEvent>>((ref) {
  final service = ref.watch(economicCalendarServiceProvider);
  
  // Fetch fresh events immediately when screen is loaded
  service.fetchEvents();
  
  // Background polling every 60 seconds while the screen is active
  final timer = Timer.periodic(const Duration(seconds: 60), (_) {
    service.fetchEvents();
  });
  
  ref.onDispose(() => timer.cancel());

  return service.watchEvents();
});

// Track if a manual/automatic refresh is actively downloading
final calendarRefreshingProvider = StateProvider<bool>((ref) => false);

// Manual refresh trigger that manages the refreshing state
final economicCalendarRefreshProvider = Provider((ref) {
  return () async {
    ref.read(calendarRefreshingProvider.notifier).state = true;
    try {
      await ref.read(economicCalendarServiceProvider).fetchEvents();
    } catch (_) {
      // Ignore or handle fetch errors gracefully
    } finally {
      ref.read(calendarRefreshingProvider.notifier).state = false;
    }
  };
});
