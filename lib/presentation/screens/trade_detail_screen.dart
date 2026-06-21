import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import 'tradingview_chart_screen.dart';
import 'trade_replay_screen.dart';

class TradeDetailScreen extends StatelessWidget {
  final Trade trade;

  const TradeDetailScreen({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    bool isWon = trade.status == TradeStatus.won;
    Color statusColor = isWon ? AppColors.success : AppColors.danger;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, statusColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(trade, statusColor),
                  const SizedBox(height: 16),
                  _buildTradingViewButton(context),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildLabel('Analysis & Screenshots'),
                  const SizedBox(height: 12),
                  _buildScreenshotPlaceholder(),
                  const SizedBox(height: 32),
                  _buildLabel('Trading Psychology'),
                  const SizedBox(height: 12),
                  _buildPsychologyCard(),
                  const SizedBox(height: 32),
                  _buildLabel('Strategy Details'),
                  const SizedBox(height: 12),
                  _buildStrategyCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Color color) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      expandedHeight: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trade screenshot copied to clipboard')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit trade - Coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(Trade trade, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            trade.status == TradeStatus.won ? 'WIN' : 'LOSS',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              trade.pair,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            Text(
              '${trade.status == TradeStatus.won ? '+' : ''}\$${trade.pnl}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${trade.direction.name.toUpperCase()} • ${trade.strategy ?? "No Strategy"} • ${_formatDate(trade.date)}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        if (trade.commission > 0 || trade.swap != 0) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (trade.commission > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_rounded, color: AppColors.textTertiary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Comm: -\$${trade.commission.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              if (trade.swap != 0)
                Row(
                  children: [
                    const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.textTertiary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Swap: ${trade.swap >= 0 ? '+' : ''}\$${trade.swap.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: trade.swap >= 0 ? AppColors.success.withValues(alpha: 0.7) : AppColors.danger.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatBox('RR Ratio', '1:3.2', AppColors.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatBox('Duration', '4h 22m', AppColors.textPrimary)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatBox('ROI', '+12.4%', AppColors.success)),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12),
    );
  }

  Widget _buildScreenshotPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surface,
        border: Border.all(color: Colors.white10),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.image_rounded, size: 48, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.zoom_in_rounded, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text('Expand', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologyCard() {
    return const GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.sentiment_satisfied_alt_rounded, color: AppColors.success),
              SizedBox(width: 12),
              Text('Confident & Patient', style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text('Discipline: 10/10', style: TextStyle(color: AppColors.success, fontSize: 12)),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "I waited for the H4 candle to close above the resistance. No FOMO. Stuck to the plan perfectly.",
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard() {
    return const GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Confluences', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag('H4 Structure'),
              _Tag('VWAP Bounce'),
              _Tag('Volume Spike'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradingViewButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradingViewChartScreen(initialPair: trade.pair),
                ),
              );
            },
            icon: const Icon(Icons.trending_up_rounded, color: Colors.black),
            label: const Text(
              'ANALISIS LIVE TRADINGVIEW',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradeReplayScreen(trade: trade),
                ),
              );
            },
            icon: const Icon(Icons.history_rounded, color: AppColors.primary),
            label: const Text(
              'PUTAR REPLAY TRADE (VISUAL)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5, color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
    );
  }
}
