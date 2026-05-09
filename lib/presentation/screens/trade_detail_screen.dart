import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';

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
                  const SizedBox(height: 32),
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
        IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
        IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () {}),
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
          '${trade.direction.name.toUpperCase()} • ${trade.strategy} • 14 Aug, 2023',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
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
