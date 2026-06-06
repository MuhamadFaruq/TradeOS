import 'package:isar/isar.dart';

part 'economic_event.g.dart';

enum Impact { low, medium, high }

@collection
class EconomicEvent {
  Id id = Isar.autoIncrement;

  late String title;
  late String country;
  late DateTime date;
  
  @enumerated
  late Impact impact;
  
  String? previous;
  String? forecast;
  String? actual;
  
  late String currency;
  
  bool isNotified = false;
}
