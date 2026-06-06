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
  
  // New metrics for growth calculation
  double initialBalance = 10000.0;
  double dailyProfitTarget = 100.0;
  double weeklyProfitTarget = 500.0;
}
