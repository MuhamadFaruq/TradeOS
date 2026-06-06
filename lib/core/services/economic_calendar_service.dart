import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/economic_event.dart';
import 'isar_service.dart';
import 'package:isar/isar.dart';

class EconomicCalendarService {
  // Replace with a real API key in production
  static const String _baseUrl = 'https://api.example.com/economic-calendar';

  static const String _realApiUrl = 'https://nfs.faireconomy.media/ff_calendar_thisweek.json';

  Future<List<EconomicEvent>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$_realApiUrl?t=${DateTime.now().millisecondsSinceEpoch}'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<EconomicEvent> events = data.map((json) {
          final String impactStr = (json['impact'] as String).toLowerCase();
          Impact impact = Impact.low;
          if (impactStr == 'medium') impact = Impact.medium;
          if (impactStr == 'high') impact = Impact.high;

          return EconomicEvent()
            ..title = json['title']
            ..country = json['country']
            ..currency = json['country']
            ..date = DateTime.parse(json['date']).toLocal()
            ..impact = impact
            ..forecast = json['forecast']
            ..previous = json['previous']
            ..actual = json['actual'];
        }).toList();

        // Save to Isar for offline access
        await IsarService.isar.writeTxn(() async {
          await IsarService.isar.economicEvents.clear();
          await IsarService.isar.economicEvents.putAll(events);
        });

        return events;
      } else {
        throw Exception('Failed to load real-time calendar');
      }
    } catch (e) {
      // Return cached data if offline
      return await IsarService.isar.economicEvents.where().sortByDate().findAll();
    }
  }

  Stream<List<EconomicEvent>> watchEvents() {
    return IsarService.isar.economicEvents.where().sortByDate().watch(fireImmediately: true);
  }
}
