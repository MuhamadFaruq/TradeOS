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
                  _buildLabel('Execution Details'),
                  const SizedBox(height: 12),
                  _buildExecutionCard(),
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
    String assetBadge = trade.assetClass.name.toUpperCase();
    if (trade.assetClass == AssetClass.cryptoSpot) assetBadge = 'SPOT';
    if (trade.assetClass == AssetClass.cryptoFutures) assetBadge = 'FUTURES';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 10),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
              ),
              child: Text(
                assetBadge,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 10),
              ),
            ),
          ],
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
              '${trade.status == TradeStatus.won ? '+' : ''}\$${trade.pnl.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${trade.direction.name.toUpperCase()} • ${trade.confluences?.join(', ') ?? "No Confluences"} • ${_formatDate(trade.date)}',
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
    final String plannedRrText = trade.plannedRRR != null 
        ? '1:${trade.plannedRRR!.toStringAsFixed(1)}' 
        : 'N/A';
    final String actualRrText = trade.actualRRR != null 
        ? '1:${trade.actualRRR!.toStringAsFixed(1)}' 
        : 'N/A';
        
    Color actualRrColor = AppColors.textPrimary;
    if (trade.plannedRRR != null && trade.actualRRR != null) {
       actualRrColor = trade.actualRRR! >= trade.plannedRRR! ? AppColors.success : AppColors.danger;
    }
        
    final String durationText = trade.durationMinutes != null 
        ? '${trade.durationMinutes}m' 
        : 'N/A';
        
    final String roiText = '${trade.pnlPercentage >= 0 ? '+' : ''}${trade.pnlPercentage.toStringAsFixed(2)}%';

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatBox('Planned RR', plannedRrText, AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatBox('Actual RR', actualRrText, actualRrColor)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatBox('Duration', durationText, AppColors.textPrimary)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatBox('ROI', roiText, trade.pnlPercentage >= 0 ? AppColors.success : AppColors.danger)),
          ],
        ),
        const SizedBox(height: 12),
        if (trade.assetClass == AssetClass.forex)
          Row(
            children: [
              Expanded(child: _buildStatBox('Lot Size', '${trade.lotSize ?? "N/A"}', Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox('Pips', '${trade.pips ?? "N/A"}', Colors.white)),
            ],
          )
        else if (trade.assetClass == AssetClass.cryptoFutures)
          Row(
            children: [
              Expanded(child: _buildStatBox('Leverage', '${trade.leverage.toStringAsFixed(0)}x', Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox('Liq Price', trade.liquidationPrice != null ? '\$${trade.liquidationPrice!.toStringAsFixed(2)}' : 'N/A', AppColors.danger)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox('Funding Fee', trade.fundingFee != null ? '\$${trade.fundingFee!.toStringAsFixed(2)}' : 'N/A', Colors.white)),
            ],
          )
        else
          Row(
            children: [
              Expanded(child: _buildStatBox('Total Investment', '\$${trade.amount.toStringAsFixed(2)}', Colors.white)),
            ],
          ),
        if (trade.mae != null || trade.mfe != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatBox('Max Adverse (MAE)', trade.mae != null ? '\$${trade.mae!.toStringAsFixed(2)}' : 'N/A', AppColors.danger)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox('Max Favorable (MFE)', trade.mfe != null ? '\$${trade.mfe!.toStringAsFixed(2)}' : 'N/A', AppColors.success)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
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

  Widget _buildExecutionCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trade.expectedEntryPrice != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expected Entry', style: TextStyle(color: AppColors.textTertiary)),
                Text('\$${trade.expectedEntryPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Actual Entry', style: TextStyle(color: AppColors.textTertiary)),
                Text('\$${trade.entryPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Slippage', style: TextStyle(color: AppColors.textTertiary)),
                Text(
                  '${trade.slippage != null ? trade.slippage!.toStringAsFixed(3) : 0}%', 
                  style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 24),
          ],
          const Text('Exits (Scaling Out)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (trade.partialExits == null || trade.partialExits!.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Full Exit At', style: TextStyle(color: AppColors.textTertiary)),
                Text(trade.exitPrice != null ? '\$${trade.exitPrice}' : 'Open', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          else
            ...trade.partialExits!.asMap().entries.map((e) {
              int index = e.key;
              var pe = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TP ${index + 1} (Amt: ${pe.amount ?? '-'})', style: const TextStyle(color: AppColors.textTertiary)),
                    Text('\$${pe.exitPrice}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildStrategyCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Confluences', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (trade.confluences == null || trade.confluences!.isEmpty) 
                ? [const _Tag('No specific confluences recorded')]
                : trade.confluences!.map((c) => _Tag(c.trim())).toList(),
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
