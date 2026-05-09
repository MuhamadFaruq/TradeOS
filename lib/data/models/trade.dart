import 'package:isar/isar.dart';

part 'trade.g.dart';

enum TradeDirection { long, short }
enum TradeStatus { won, lost, open }

@collection
class Trade {
  Id id = Isar.autoIncrement;
  
  @Index(type: IndexType.value)
  late String pair;
  
  @enumerated
  late TradeDirection direction;
  
  late double entryPrice;
  double? exitPrice;
  late double amount;
  late double pnl;
  late double pnlPercentage;
  double leverage = 1.0;
  bool isLong = true;
  
  @enumerated
  late TradeStatus status;
  
  late DateTime date;
  String? strategy;
  String? notes;
  
  // Psychological factors
  String? emotion;
  String? session;
  int? confidence;

  Trade();

  // For migration/mocking convenience
  Trade.create({
    required this.pair,
    required this.direction,
    required this.entryPrice,
    this.exitPrice,
    required this.amount,
    required this.pnl,
    required this.pnlPercentage,
    required this.status,
    required this.date,
    this.strategy,
    this.notes,
    this.emotion,
    this.session,
    this.confidence,
  });
}
