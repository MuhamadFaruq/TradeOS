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
  bool hapticEnabled = true;
  String? appPasscode;
  
  // New metrics for growth calculation
  double initialBalance = 0.0;
  double dailyProfitTarget = 0.0;
  double weeklyProfitTarget = 0.0;

  List<String> tradingAccounts = ['Primary Personal', 'Prop Firm Phase 1'];
}
