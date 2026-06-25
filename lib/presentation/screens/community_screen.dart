import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';
import '../../data/providers/profile_provider.dart';
import '../../data/models/trade.dart';
import '../../core/services/export_service.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final profile = ref.watch(profileProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Social & Auditing', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Feed'),
              Tab(text: 'Mentor Audit'),
              Tab(text: 'Top Strategies'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildJournalFeed(context, trades, profile?.name ?? 'Alex Trader'),
            _buildMentorReview(context, trades, profile),
            _buildLeaderboard(trades),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalFeed(BuildContext context, List<Trade> trades, String userName) {
    // Show only trades that have notes or are closed to keep the feed interesting
    final feedTrades = trades.where((t) => (t.notes != null && t.notes!.isNotEmpty) || t.status != TradeStatus.open).toList();

    if (feedTrades.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dynamic_feed_rounded, color: AppColors.textTertiary, size: 48),
            SizedBox(height: 16),
            Text('Feed is empty.', style: TextStyle(color: AppColors.textSecondary)),
            SizedBox(height: 8),
            Text('Log trades with notes or screenshots to see them here.', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: feedTrades.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final trade = feedTrades[index];
        final isWon = trade.pnl >= 0;
        final sign = isWon ? '+' : '';
        final color = isWon ? AppColors.success : AppColors.danger;
        final assetBadge = trade.assetClass == AssetClass.forex ? 'FOREX' : (trade.assetClass == AssetClass.cryptoFutures ? 'FUTURES' : 'SPOT');

        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase(),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        DateFormat('MMM dd, HH:mm').format(trade.date),
                        style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${trade.direction.name.toUpperCase()} ${trade.pair}',
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                trade.notes ?? 'No analysis note entered. Logged a ${trade.direction.name} setup on ${trade.pair} with ${trade.confluences?.join(', ') ?? "No Confluences"}.',
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              
              // Mock/Actual screenshot rendering
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface,
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.show_chart_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Setup Details ($assetBadge)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          Text(
                            'Entry: \$${trade.entryPrice.toStringAsFixed(2)} • Exit: ${trade.exitPrice != null ? "\$${trade.exitPrice!.toStringAsFixed(2)}" : "Open"}',
                            style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$sign\$${trade.pnl.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMentorReview(BuildContext context, List<Trade> trades, dynamic profile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 64),
          const SizedBox(height: 24),
          const Text('Audit Your Performance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Generate your verified journal report as a premium PDF to share with your trading coach, mentor, or risk auditor.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: GlowingButton(
              text: 'SHARE PDF REPORT',
              onPressed: () async {
                if (trades.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No trades available to audit.')),
                  );
                  return;
                }
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );

                try {
                  final path = await ExportService.exportToPdf(trades, profile);
                  if (context.mounted) {
                    Navigator.pop(context); // close loading
                    await ExportService.shareFile(path, 'TradeOS Verified Audit');
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context); // close loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error generating audit PDF: $e'), backgroundColor: AppColors.danger),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(List<Trade> trades) {
    // Group trades by strategy
    final Map<String, List<Trade>> strategyGroups = {};
    for (var trade in trades) {
      if (trade.confluences != null && trade.confluences!.isNotEmpty) {
        strategyGroups.putIfAbsent(trade.confluences!.join(', ').trim(), () => []).add(trade);
      }
    }

    final List<Map<String, dynamic>> strategyStats = [];
    strategyGroups.forEach((strategy, list) {
      final closed = list.where((t) => t.status == TradeStatus.won || t.status == TradeStatus.lost).toList();
      final wins = closed.where((t) => t.status == TradeStatus.won).length;
      final winRate = closed.isEmpty ? 0.0 : (wins / closed.length) * 100;
      final totalPnl = list.fold(0.0, (sum, t) => sum + t.pnl);
      strategyStats.add({
        'name': strategy,
        'winRate': winRate,
        'totalPnl': totalPnl,
        'count': list.length,
      });
    });

    // Sort by winRate and then totalPnl descending
    strategyStats.sort((a, b) {
      int cmp = (b['winRate'] as double).compareTo(a['winRate'] as double);
      if (cmp != 0) return cmp;
      return (b['totalPnl'] as double).compareTo(a['totalPnl'] as double);
    });

    if (strategyStats.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard_rounded, color: AppColors.textTertiary, size: 48),
            SizedBox(height: 16),
            Text('No strategies recorded yet.', style: TextStyle(color: AppColors.textSecondary)),
            SizedBox(height: 8),
            Text('Enter strategies when adding trades to populate the leaderboard.', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: strategyStats.length,
      itemBuilder: (context, index) {
        final stat = strategyStats[index];
        final double winRate = stat['winRate'];
        final double totalPnl = stat['totalPnl'];
        final int count = stat['count'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 16),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stat['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('$count trades total', style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${winRate.toStringAsFixed(0)}% WR', style: TextStyle(color: winRate >= 50 ? AppColors.success : AppColors.danger, fontWeight: FontWeight.bold)),
                    Text(
                      '${totalPnl >= 0 ? "+" : ""}\$${totalPnl.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 10, color: totalPnl >= 0 ? AppColors.success.withValues(alpha: 0.7) : AppColors.danger.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
