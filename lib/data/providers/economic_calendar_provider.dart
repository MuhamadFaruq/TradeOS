import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/economic_event.dart';
import '../../core/services/economic_calendar_service.dart';

final economicCalendarServiceProvider = Provider((ref) => EconomicCalendarService());

final economicCalendarProvider = StreamProvider<List<EconomicEvent>>((ref) {
  final service = ref.watch(economicCalendarServiceProvider);
  
  // Initial fetch to populate Isar
  service.fetchEvents();
  
  // Set up periodic fetching in the background to simulate real-time updates from server
  final timer = Timer.periodic(const Duration(minutes: 5), (_) {
    service.fetchEvents();
  });
  
  ref.onDispose(() => timer.cancel());

  return service.watchEvents();
});

// For manual refresh trigger
final economicCalendarRefreshProvider = Provider((ref) {
  return () => ref.read(economicCalendarServiceProvider).fetchEvents();
});
