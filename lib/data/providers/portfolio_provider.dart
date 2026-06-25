import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/portfolio.dart';
import '../../core/services/isar_service.dart';

final portfolioProvider = StateNotifierProvider<PortfolioNotifier, List<Portfolio>>((ref) {
  return PortfolioNotifier();
});

// A simple provider to expose the currently active portfolio ID
final activePortfolioIdProvider = StateProvider<int?>((ref) => null);

class PortfolioNotifier extends StateNotifier<List<Portfolio>> {
  PortfolioNotifier() : super([]) {
    _loadPortfolios();
  }

  Future<void> _loadPortfolios() async {
    final isar = await IsarService.getInstance();
    final portfolios = await isar.portfolios.where().findAll();
    
    if (portfolios.isEmpty) {
      // Create a default portfolio if none exist
      final defaultPortfolio = Portfolio.create(
        name: 'Default Account',
        initialBalance: 0,
        type: 'Personal',
        isDefault: true,
      );
      
      await isar.writeTxn(() async {
        await isar.portfolios.put(defaultPortfolio);
      });
      
      state = [defaultPortfolio];
    } else {
      state = portfolios;
    }
  }

  Future<void> addPortfolio(Portfolio portfolio) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      await isar.portfolios.put(portfolio);
    });
    await _loadPortfolios();
  }

  Future<void> updatePortfolio(Portfolio portfolio) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      await isar.portfolios.put(portfolio);
    });
    await _loadPortfolios();
  }
}
