import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class StrategyLibraryScreen extends StatelessWidget {
  const StrategyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Strategy Playbook', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create new strategy coming soon...')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildStrategyCard(context,
            'Bull Flag Breakout',
            'Trend following setup on H1/H4 timeframes.',
            '82%',
            '1:2.5',
          ),
          const SizedBox(height: 16),
          _buildStrategyCard(context,
            'Mean Reversion (VWAP)',
            'Shorting extended moves outside 2nd deviation.',
            '54%',
            '1:3.0',
          ),
          const SizedBox(height: 16),
          _buildStrategyCard(context,
            'Support Flip',
            'Buying retests of broken resistance levels.',
            '68%',
            '1:2.0',
          ),
          const SizedBox(height: 32),
          _buildLabel('Backtesting Session'),
          const SizedBox(height: 16),
          _buildBacktestCTA(context),
        ],
      ),
    );
  }

  Widget _buildStrategyCard(BuildContext context, String name, String desc, String winRate, String rr) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Icon(Icons.more_vert_rounded, color: AppColors.textTertiary),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStat('Win Rate', winRate, AppColors.success),
              const SizedBox(width: 24),
              _buildStat('Avg RR', rr, AppColors.primary),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing rules for: $name')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('View Rules', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildBacktestCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.history_rounded, color: AppColors.primary, size: 40),
          const SizedBox(height: 16),
          const Text('New Backtesting Session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            'Test your setup against historical data to confirm your edge.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 20),
          GlowingButton(text: 'START SESSION', onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backtesting session started! (Demo)')),
            );
          }),
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
