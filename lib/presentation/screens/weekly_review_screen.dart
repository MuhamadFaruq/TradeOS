import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';

class WeeklyReviewScreen extends ConsumerWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Weekly Review', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeeklySummaryCard(notifier.totalPnL, notifier.winRate),
            const SizedBox(height: 32),
            _buildLabel('AI Core Insights'),
            const SizedBox(height: 16),
            if (trades.isEmpty)
              const Center(child: Text('No data for review yet.', style: TextStyle(color: AppColors.textTertiary)))
            else ...[
              _buildReviewInsight(
                'Psychology Check',
                'Your discipline score is based on the ${trades.length} trades recorded. Stay focused on your H1 setups.',
                Icons.psychology_rounded,
              ),
              const SizedBox(height: 16),
              _buildReviewInsight(
                'Strategy Edge',
                'Your most frequent strategy this week was "${trades.first.strategy ?? "Unknown"}". Performance is being analyzed.',
                Icons.auto_graph_rounded,
              ),
            ],
            const SizedBox(height: 32),
            _buildLabel('Action Plan for Next Week'),
            const SizedBox(height: 16),
            const GlassCard(
              child: Column(
                children: [
                  _ActionItem('Skip NY session on Thursdays.', true),
                  Divider(color: Colors.white10),
                  _ActionItem('Focus exclusively on H1 setups.', false),
                  Divider(color: Colors.white10),
                  _ActionItem('Maintain 1:2.5 minimum RR.', false),
                ],
              ),
            ),
            const SizedBox(height: 40),
            GlowingButton(text: 'COMPLETE REVIEW', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard(double pnl, double winRate) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Performance Summary', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('Net Profit', '${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(0)}', pnl >= 0 ? AppColors.success : AppColors.danger),
              _buildMetric('Win Rate', '${winRate.toStringAsFixed(0)}%', AppColors.primary),
              _buildMetric('Discipline', '8/10', AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
      ],
    );
  }

  Widget _buildReviewInsight(String title, String desc, IconData icon) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
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
}

class _ActionItem extends StatelessWidget {
  final String text;
  final bool isCompleted;
  const _ActionItem(this.text, this.isCompleted);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined, color: isCompleted ? AppColors.success : AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: isCompleted ? Colors.white : AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
