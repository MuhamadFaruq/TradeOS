import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  String name = 'Alex Trader';
  String email = 'alex@tradeos.com';
  bool biometricsEnabled = false;
  bool notificationsEnabled = true;
  String defaultCurrency = 'USD';
  double defaultRiskPercent = 1.0;
}
