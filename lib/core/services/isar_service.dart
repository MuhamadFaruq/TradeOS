import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/trade.dart';
import '../../data/models/user_profile.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TradeSchema, UserProfileSchema],
      directory: dir.path,
    );
  }
}
