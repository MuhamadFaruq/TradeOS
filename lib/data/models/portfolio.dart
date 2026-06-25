import 'package:isar/isar.dart';

part 'portfolio.g.dart';

@collection
class Portfolio {
  Id id = Isar.autoIncrement;

  late String name;
  late double initialBalance;
  late String type; // 'Prop Firm', 'Personal', 'Demo'
  bool isDefault = false;

  Portfolio();

  Portfolio.create({
    required this.name,
    required this.initialBalance,
    required this.type,
    this.isDefault = false,
  });
}
