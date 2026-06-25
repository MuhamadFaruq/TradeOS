import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/trade.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/economic_event.dart';

import '../../data/models/portfolio.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    // Check if instance already exists
    if (Isar.getInstance() != null) {
      isar = Isar.getInstance()!;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [TradeSchema, UserProfileSchema, EconomicEventSchema, PortfolioSchema],
      directory: dir.path,
    );
  }

  // Helper method to get or initialize instance
  static Future<Isar> getInstance() async {
    if (Isar.getInstance() != null) {
      return Isar.getInstance()!;
    }
    await init();
    return isar;
  }
}

