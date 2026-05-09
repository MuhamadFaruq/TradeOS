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
  double get totalPnL => state.fold(0, (sum, item) => sum + item.pnl);
  
  double get winRate {
    if (state.isEmpty) return 0;
    final wins = state.where((t) => t.status == TradeStatus.won).length;
    return (wins / state.length) * 100;
  }

  double get profitFactor {
    final grossProfit = state.where((t) => t.pnl > 0).fold(0.0, (sum, t) => sum + t.pnl);
    final grossLoss = state.where((t) => t.pnl < 0).fold(0.0, (sum, t) => sum + t.pnl.abs());
    if (grossLoss == 0) return grossProfit > 0 ? 99.0 : 0.0;
    return grossProfit / grossLoss;
  }

  Future<void> clearAllTrades() async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.trades.clear();
    });
    await _loadTrades();
  }
}
