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

  Future<void> _loadTrades() async {
    final trades = await IsarService.isar.trades.where().sortByDateDesc().findAll();
    state = trades;
  }

  Future<void> addTrade(Trade trade) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.trades.put(trade);
    });
    await _loadTrades();
  }

  Future<void> deleteTrade(int id) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.trades.delete(id);
    });
    await _loadTrades();
  }

  // Statistics calculations
  double get totalPnL {
    if (state.isEmpty) return 0.0;
    return state.fold(0.0, (sum, item) => sum + item.pnl);
  }
  
  double get winRate {
    // Only count closed trades (won or lost)
    final closedTrades = state.where((t) => 
      t.status == TradeStatus.won || t.status == TradeStatus.lost).toList();
    
    if (closedTrades.isEmpty) return 0.0;
    
    final wins = closedTrades.where((t) => t.status == TradeStatus.won).length;
    return (wins / closedTrades.length) * 100;
  }

  double get profitFactor {
    final grossProfit = state.where((t) => t.pnl > 0).fold(0.0, (sum, t) => sum + t.pnl);
    final grossLoss = state.where((t) => t.pnl < 0).fold(0.0, (sum, t) => sum + t.pnl.abs());
    
    if (grossLoss == 0) {
      return grossProfit > 0 ? double.infinity : 0.0;
    }
    return grossProfit / grossLoss;
  }

  // Account Growth Calculation
  double calculateGrowth(double initialBalance) {
    if (initialBalance <= 0) return 0.0;
    return (totalPnL / initialBalance) * 100;
  }

  Future<void> clearAllTrades() async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.trades.clear();
    });
    await _loadTrades();
  }
}
