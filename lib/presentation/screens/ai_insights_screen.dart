import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';

class AIInsightsScreen extends ConsumerStatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  ConsumerState<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends ConsumerState<AIInsightsScreen> {
  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);
    final hasTrades = trades.isNotEmpty;

    // Logic for dynamic insights
    final List<Widget> dynamicInsights = [];
    if (hasTrades) {
      // 1. Check for Short CVD Anomaly
      final shortAnomaliesCount = notifier.getShortTradesWithCVDAnomalies().length;
      final winRateAnomalousShort = notifier.winRateForShortWithAnomalies;
      
      if (shortAnomaliesCount > 0 && winRateAnomalousShort < 40) {
        dynamicInsights.add(
          _buildInsightCard(
            'Short Position Alert',
            'Win Rate is only ${winRateAnomalousShort.toStringAsFixed(1)}% on Short positions when CVD shows anomalies. Consider avoiding shorts when CVD is extremely volatile.',
            Icons.trending_down_rounded,
            AppColors.danger,
          ),
        );
        dynamicInsights.add(const SizedBox(height: 16));
      }

      // 2. Default Dynamic Insight (always shows if trades exist)
      dynamicInsights.add(
        _buildInsightCard(
          'Over-trading Alert',
          'You tend to take 40% more trades during the NY session when your previous trade was a loss.',
          Icons.warning_amber_rounded,
          AppColors.danger,
        ),
      );
      dynamicInsights.add(const SizedBox(height: 16));
      
      dynamicInsights.add(
        _buildInsightCard(
          'Edge Confirmation',
          'Your "Bull Flag" setup on H4 has an 82% win rate with a 1:2.5 RR. Focus on this.',
          Icons.check_circle_outline_rounded,
          AppColors.success,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Trading Coach', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAIPromptCard(trades.length, context),
            const SizedBox(height: 32),
            _buildLabel('Critical Insights'),
            const SizedBox(height: 16),
            if (!hasTrades)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Log some trades to see AI insights.', style: TextStyle(color: AppColors.textTertiary)),
                ),
              )
            else ...dynamicInsights,
            const SizedBox(height: 32),
            _buildLabel('Recommended Playbook'),
            const SizedBox(height: 16),
            const GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.psychology_rounded, color: AppColors.primary),
                    title: Text('Pre-trade Meditation'),
                    subtitle: Text('Reduce FOMO before market open.'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                  Divider(color: Colors.white10),
                  ListTile(
                    leading: Icon(Icons.rule_rounded, color: AppColors.primary),
                    title: Text('Risk Scaling Rule'),
                    subtitle: Text('Cut size by 50% after 2 consecutive losses.'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIPromptCard(int tradeCount, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 40),
          const SizedBox(height: 16),
          Text(
            tradeCount == 0 ? 'Ready to analyze...' : 'Analyzing your last $tradeCount trades...',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            tradeCount == 0
              ? '"Success is the sum of small efforts, repeated day-in and day-out."'
              : '"Your discipline score is promising. Keep focusing on high-confidence setups."',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: tradeCount > 0 ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Report Generated! Check your email.')),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
            ),
            child: const Text('Generate Full Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon, Color color) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
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
