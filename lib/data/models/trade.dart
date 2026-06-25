import 'package:isar/isar.dart';

part 'trade.g.dart';

enum TradeDirection { long, short }
enum TradeStatus { won, lost, breakEven, pending, open }
enum AssetClass { forex, cryptoSpot, cryptoFutures }

@collection
class Trade {
  Id id = Isar.autoIncrement;

  // === BASIC TRADE INFO ===
  @Index(type: IndexType.value)
  late String pair;

  @enumerated
  late TradeDirection direction;

  @enumerated
  late AssetClass assetClass;

  int? portfolioId;

  late double entryPrice;
  double? exitPrice;
  late double amount;
  late double pnl;
  late double pnlPercentage;
  double leverage = 1.0;
  double commission = 0.0;
  double swap = 0.0;

  // === ASSET CLASS SPECIFIC FIELDS ===
  double? lotSize;          // For Forex
  double? pips;             // For Forex
  double? liquidationPrice; // For Crypto Futures
  double? fundingFee;       // For Crypto Futures

  @enumerated
  late TradeStatus status;

  bool get isLong => direction == TradeDirection.long;

  @Index()
  late DateTime date;
  String? notes;

  // === PSYCHOLOGICAL FACTORS ===
  String? emotion;
  String? session;
  int? confidence;

  // === MISTAKE / RULE BREAKING TRACKING ===
  bool wasRuleBroken = false;
  String? brokenRule;

  // === ADVANCED METRICS (Order Flow Analysis) ===
  // Cumulative Volume Delta - difference between buy volume and sell volume
  double? cvd;

  // Volume Imbalance - ratio of buy to sell volume
  double? volumeImbalance;

  // Total volume traded
  double? totalVolume;

  // Price Action metrics
  double? highPrice;
  double? lowPrice;

  // Time-based metrics
  int? durationMinutes; // Duration of trade in minutes
  int? durationHours;   // Duration of trade in hours

  // Risk metrics
  double? stopLossPrice;
  double? takeProfitPrice;
  double? plannedRRR; // Formerly riskRewardRatio
  double? actualRRR;
  double? mae; // Maximum Adverse Excursion
  double? mfe; // Maximum Favorable Excursion

  // Execution Metrics
  double? expectedEntryPrice;
  double? slippage; // Difference between expected and actual entry

  // Confluences (Replaces single strategy)
  List<String>? confluences;

  // Partial Exits
  List<PartialExit>? partialExits;

  // === CHART SCREENSHOTS ===
  // List of file paths untuk screenshot sebelum entry
  List<String>? beforeEntryScreenshots;

  // List of file paths untuk screenshot setelah exit
  List<String>? afterExitScreenshots;

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
    this.assetClass = AssetClass.cryptoSpot,
    this.portfolioId,
    this.lotSize,
    this.pips,
    this.liquidationPrice,
    this.fundingFee,
    this.notes,
    this.emotion,
    this.session,
    this.confidence,
    this.wasRuleBroken = false,
    this.brokenRule,
    this.commission = 0.0,
    this.swap = 0.0,
    this.cvd,
    this.volumeImbalance,
    this.totalVolume,
    this.highPrice,
    this.lowPrice,
    this.durationMinutes,
    this.durationHours,
    this.stopLossPrice,
    this.takeProfitPrice,
    this.plannedRRR,
    this.actualRRR,
    this.mae,
    this.mfe,
    this.expectedEntryPrice,
    this.slippage,
    this.confluences,
    this.partialExits,
    this.beforeEntryScreenshots,
    this.afterExitScreenshots,
  });

  // Helper method untuk check apakah ada screenshots
  bool hasScreenshots() {
    return (beforeEntryScreenshots?.isNotEmpty ?? false) ||
        (afterExitScreenshots?.isNotEmpty ?? false);
  }

  // Helper untuk detect anomalies based on CVD
  bool hasCVDAnomaly() {
    if (cvd == null) return false;
    // Anomaly jika CVD ekstrem (> 50% atau < -50%)
    return cvd!.abs() > 0.5;
  }

  // Helper untuk detect volume anomaly
  bool hasVolumeAnomaly() {
    if (volumeImbalance == null) return false;
    // Anomaly jika imbalance > 0.7 atau < 0.3
    return volumeImbalance! > 0.7 || volumeImbalance! < 0.3;
  }
}

@embedded
class PartialExit {
  double? exitPrice;
  double? amount; // Amount or lot size closed
  DateTime? date;

  PartialExit({
    this.exitPrice,
    this.amount,
    this.date,
  });
}
