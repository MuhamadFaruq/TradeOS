import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/trade.dart';
import '../../core/services/isar_service.dart';

final tradeProvider = StateNotifierProvider<TradeNotifier, List<Trade>>((ref) {
  return TradeNotifier();
});

class TradeNotifier extends StateNotifier<List<Trade>> {

  TradeNotifier() : super([]) {
    _loadTrades();
  }

  // Load all trades from Isar
  Future<void> _loadTrades() async {
    try {
      final isar = await IsarService.getInstance();
      state = await isar.trades.where().sortByDateDesc().findAll();
    } catch (e) {
      print('Error loading trades: $e');
    }
  }

  // Reload trades from DB
  Future<void> refreshTrades() async {
    await _loadTrades();
  }

  Future<void> addTrade(Trade trade) async {
    try {
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await isar.trades.put(trade);
      });
      await refreshTrades(); // Reload dari awal setelah add
    } catch (e) {
      print('Error adding trade: $e');
    }
  }

  Future<void> deleteTrade(int id) async {
    try {
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await isar.trades.delete(id);
      });
      await refreshTrades(); // Reload setelah delete
    } catch (e) {
      print('Error deleting trade: $e');
    }
  }

  double get totalPnL {
    if (state.isEmpty) return 0.0;
    return state.fold(0.0, (sum, item) => sum + item.pnl);
  }

  double get mistakeCosts {
    final mistakeTrades = state.where((t) => t.wasRuleBroken && t.pnl < 0).toList();
    return mistakeTrades.fold(0.0, (sum, t) => sum + t.pnl.abs());
  }

  double get disciplineRate {
    if (state.isEmpty) return 100.0;
    final total = state.length;
    final broken = state.where((t) => t.wasRuleBroken).length;
    return ((total - broken) / total) * 100;
  }

  double get disciplinedPnL {
    final disciplinedTrades = state.where((t) => !t.wasRuleBroken).toList();
    return disciplinedTrades.fold(0.0, (sum, t) => sum + t.pnl);
  }

  double get winRate {
    // Only count closed trades (won or lost)
    final closedTrades = state
        .where((t) => t.status == TradeStatus.won || t.status == TradeStatus.lost)
        .toList();

    if (closedTrades.isEmpty) return 0.0;

    final wins = closedTrades.where((t) => t.status == TradeStatus.won).length;
    return (wins / closedTrades.length) * 100;
  }

  double get profitFactor {
    final closedTrades = state
        .where((t) => t.status == TradeStatus.won || t.status == TradeStatus.lost)
        .toList();
    
    final grossProfit =
        closedTrades.where((t) => t.pnl > 0).fold(0.0, (sum, t) => sum + t.pnl);
    final grossLoss =
        closedTrades.where((t) => t.pnl < 0).fold(0.0, (sum, t) => sum + t.pnl.abs());

    if (grossLoss == 0) {
      return grossProfit > 0 ? 999.99 : 0.0;
    }
    return grossProfit / grossLoss;
  }

  // === LONG POSITION METRICS ===
  double get longTotalPnL {
    final longTrades = state.where((t) => t.direction == TradeDirection.long).toList();
    if (longTrades.isEmpty) return 0.0;
    return longTrades.fold(0.0, (sum, item) => sum + item.pnl);
  }

  double get longWinRate {
    final closedLongs = state.where((t) =>
        t.direction == TradeDirection.long &&
        (t.status == TradeStatus.won || t.status == TradeStatus.lost)).toList();

    if (closedLongs.isEmpty) return 0.0;

    final wins = closedLongs.where((t) => t.status == TradeStatus.won).length;
    return (wins / closedLongs.length) * 100;
  }

  double get longProfitFactor {
    final longTrades = state.where((t) => t.direction == TradeDirection.long).toList();
    final grossProfit =
        longTrades.where((t) => t.pnl > 0).fold(0.0, (sum, t) => sum + t.pnl);
    final grossLoss =
        longTrades.where((t) => t.pnl < 0).fold(0.0, (sum, t) => sum + t.pnl.abs());

    if (grossLoss == 0) {
      return grossProfit > 0 ? 999.99 : 0.0;
    }
    return grossProfit / grossLoss;
  }

  int get longTradeCount {
    return state.where((t) => t.direction == TradeDirection.long).length;
  }

  // === SHORT POSITION METRICS ===
  double get shortTotalPnL {
    final shortTrades = state.where((t) => t.direction == TradeDirection.short).toList();
    if (shortTrades.isEmpty) return 0.0;
    return shortTrades.fold(0.0, (sum, item) => sum + item.pnl);
  }

  double get shortWinRate {
    final closedShorts = state.where((t) =>
        t.direction == TradeDirection.short &&
        (t.status == TradeStatus.won || t.status == TradeStatus.lost)).toList();

    if (closedShorts.isEmpty) return 0.0;

    final wins = closedShorts.where((t) => t.status == TradeStatus.won).length;
    return (wins / closedShorts.length) * 100;
  }

  double get shortProfitFactor {
    final shortTrades = state.where((t) => t.direction == TradeDirection.short).toList();
    final grossProfit =
        shortTrades.where((t) => t.pnl > 0).fold(0.0, (sum, t) => sum + t.pnl);
    final grossLoss =
        shortTrades.where((t) => t.pnl < 0).fold(0.0, (sum, t) => sum + t.pnl.abs());

    if (grossLoss == 0) {
      return grossProfit > 0 ? 999.99 : 0.0;
    }
    return grossProfit / grossLoss;
  }

  int get shortTradeCount {
    return state.where((t) => t.direction == TradeDirection.short).length;
  }

  // === ADVANCED FILTERING ===
  List<Trade> getTradesByDirection(TradeDirection direction) {
    return state.where((t) => t.direction == direction).toList();
  }

  List<Trade> getTradesByStrategy(String strategy) {
    return state.where((t) => t.strategy == strategy).toList();
  }

  List<Trade> getShortTradesWithCVDAnomalies() {
    return state.where((t) => 
      t.direction == TradeDirection.short && 
      t.hasCVDAnomaly()
    ).toList();
  }

  double get winRateForShortWithAnomalies {
    final anomalousShorts = getShortTradesWithCVDAnomalies()
        .where((t) => t.status == TradeStatus.won || t.status == TradeStatus.lost)
        .toList();
    
    if (anomalousShorts.isEmpty) return 0.0;
    
    final wins = anomalousShorts.where((t) => t.status == TradeStatus.won).length;
    return (wins / anomalousShorts.length) * 100;
  }

  List<Trade> getTradesWithAnomalies() {
    return state.where((t) => t.hasCVDAnomaly() || t.hasVolumeAnomaly()).toList();
  }

  List<Trade> getTradesWithScreenshots() {
    return state.where((t) => t.hasScreenshots()).toList();
  }

  // Account Growth Calculation
  double calculateGrowth(double initialBalance) {
    if (initialBalance <= 0) return 0.0;
    return (totalPnL / initialBalance) * 100;
  }

  Future<void> addTrades(List<Trade> newTrades) async {
    try {
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await isar.trades.putAll(newTrades);
      });
      await refreshTrades();
    } catch (e) {
      print('Error adding batch trades: $e');
    }
  }

  Future<void> clearAllTrades() async {
    try {
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await isar.trades.clear();
      });
      await refreshTrades();
    } catch (e) {
      print('Error clearing trades: $e');
    }
  }

  // Get total count without limit (untuk UI info)
  Future<int> getTotalTradeCount() async {
    try {
      final isar = await IsarService.getInstance();
      return await isar.trades.where().count();
    } catch (e) {
      print('Error getting trade count: $e');
      return 0;
    }
  }
}
