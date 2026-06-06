import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import '../../data/providers/trade_provider.dart';
import 'trade_detail_screen.dart';

class JournalListScreen extends ConsumerStatefulWidget {
  const JournalListScreen({super.key});

  @override
  ConsumerState<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends ConsumerState<JournalListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Won', 'Lost', 'Open'];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradeProvider);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildFilterChips(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _buildTradesList(trades),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      title: const Text('Trading Journal', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.surface,
              builder: (context) => Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text('Status', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _filters.map((filter) {
                        bool isSelected = _selectedFilter == filter;
                        return ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFilter = filter);
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() {}),
        decoration: const InputDecoration(
          hintText: 'Search trades, pairs, strategies...',
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: AppColors.textTertiary),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          bool isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? AppColors.primary : Colors.white10),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTradesList(List<Trade> allTrades) {
    final query = _searchController.text.toLowerCase();
    
    final filteredTrades = allTrades.where((trade) {
      // Status Filter
      if (_selectedFilter != 'All') {
        if (_selectedFilter == 'Won' && trade.status != TradeStatus.won) return false;
        if (_selectedFilter == 'Lost' && trade.status != TradeStatus.lost) return false;
        if (_selectedFilter == 'Open' && trade.status != TradeStatus.open) return false;
      }
      
      // Search Filter
      if (query.isNotEmpty) {
        final matchesPair = trade.pair.toLowerCase().contains(query);
        final matchesStrategy = (trade.strategy ?? '').toLowerCase().contains(query);
        if (!matchesPair && !matchesStrategy) return false;
      }
      
      return true;
    }).toList();

    if (filteredTrades.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No trades found.', style: TextStyle(color: AppColors.textTertiary)),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final trade = filteredTrades[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TradeDetailScreen(trade: trade)),
                );
              },
              child: Dismissible(
                key: Key(trade.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                ),
                onDismissed: (_) {
                  ref.read(tradeProvider.notifier).deleteTrade(trade.id);
                },
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildTradeStatusIndicator(trade),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trade.pair,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${trade.direction.name.toUpperCase()} • ${trade.strategy ?? "No Strategy"}',
                              style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${trade.pnl >= 0 ? '+' : ''}\$${trade.pnl.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: trade.pnl >= 0 ? AppColors.success : AppColors.danger,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(trade.date),
                            style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: filteredTrades.length,
      ),
    );
  }

  Widget _buildTradeStatusIndicator(Trade trade) {
    bool isWon = trade.status == TradeStatus.won;
    Color color = isWon ? AppColors.success : AppColors.danger;
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Icon(
        trade.direction == TradeDirection.long ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
        color: color,
      ),
    );
  }
}
