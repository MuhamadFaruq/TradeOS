import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final tradeCount = trades.length;
    
    // Example calculations for goals
    final winRate = ref.read(tradeProvider.notifier).winRate;
    final winningStreaks = _calculateWinningStreak(trades);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Goals & Habits', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildStreakCard(winningStreaks),
          const SizedBox(height: 32),
          _buildLabel('Current Goals'),
          const SizedBox(height: 16),
          _buildGoalItem('Log 20 Trades', tradeCount, 20, Icons.book_rounded),
          const SizedBox(height: 12),
          _buildGoalItem('Maintain >50% Win Rate', winRate.toInt(), 100, Icons.trending_up_rounded),
          const SizedBox(height: 12),
          _buildGoalItem('Consistency Target', (tradeCount % 10), 10, Icons.psychology_rounded),
          const SizedBox(height: 32),
          _buildLabel('Achievements'),
          const SizedBox(height: 16),
          _buildAchievementsGrid(tradeCount, winRate),
        ],
      ),
    );
  }

  int _calculateWinningStreak(List<dynamic> trades) {
    int currentStreak = 0;
    for (var trade in trades) {
      if (trade.status.name == 'won') {
        currentStreak++;
      } else {
        break;
      }
    }
    return currentStreak;
  }

  Widget _buildStreakCard(int streak) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 64),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$streak WIN STREAK', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const Text('Keep logging to maintain your edge!', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, int current, int target, IconData icon) {
    double progress = (current / target).clamp(0.0, 1.0);
    return GlassCard(
      enableBlur: false,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text('$current/$target', style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(int tradeCount, double winRate) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildAchievementIcon(Icons.military_tech_rounded, 'First 10', tradeCount >= 10),
        _buildAchievementIcon(Icons.auto_graph_rounded, 'Profit Maker', winRate > 50 && tradeCount > 0),
        _buildAchievementIcon(Icons.workspace_premium_rounded, 'Consistency', tradeCount >= 50),
      ],
    );
  }

  Widget _buildAchievementIcon(IconData icon, String label, bool isUnlocked) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? AppColors.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          ),
          child: Icon(icon, color: isUnlocked ? AppColors.primary : Colors.white10),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10, color: isUnlocked ? Colors.white : AppColors.textTertiary), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12),
    );
  }
}
