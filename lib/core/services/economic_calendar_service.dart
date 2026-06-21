import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/economic_event.dart';
import 'isar_service.dart';
import 'package:isar/isar.dart';

class EconomicCalendarService {
  static const String _realApiUrl = 'https://nfs.faireconomy.media/ff_calendar_thisweek.json';

  Future<List<EconomicEvent>> fetchEvents({DateTime? start, DateTime? end}) async {
    try {
      // Use this week's data by default
      final response = await http.get(Uri.parse('$_realApiUrl?t=${DateTime.now().millisecondsSinceEpoch}'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<EconomicEvent> events = [];
        
        for (var item in data) {
          try {
            final String impactStr = (item['impact'] as String).toLowerCase();
            Impact impactLevel = Impact.low;
            if (impactStr == 'medium') impactLevel = Impact.medium;
            if (impactStr == 'high') impactLevel = Impact.high;

            final event = EconomicEvent()
              ..title = item['title'] ?? 'Unknown Event'
              ..country = item['country'] ?? ''
              ..currency = item['country'] ?? ''
              ..date = DateTime.parse(item['date']).toLocal()
              ..impact = impactLevel
              ..forecast = item['forecast']
              ..previous = item['previous']
              ..actual = item['actual'];
            
            events.add(event);
          } catch (e) {
            print('Error parsing event: $e');
          }
        }

        // Save to Isar
        await IsarService.isar.writeTxn(() async {
          // Only clear and replace if we fetched a full week or significant range
          // For now, keep it simple as the free API provides week-at-a-time
          await IsarService.isar.economicEvents.clear();
          await IsarService.isar.economicEvents.putAll(events);
        });

        return events;
      } else {
        throw Exception('Failed to load real-time calendar');
      }
    } catch (e) {
      print('Fetch error: $e');
      return await IsarService.isar.economicEvents.where().sortByDate().findAll();
    }
  }

  Stream<List<EconomicEvent>> watchEvents() {
    return IsarService.isar.economicEvents.where().sortByDate().watch(fireImmediately: true);
  }
}
