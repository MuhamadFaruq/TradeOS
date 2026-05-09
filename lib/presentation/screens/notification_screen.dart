import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Mark all read')),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildNotificationCard(index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(int index) {
    final types = ['Trade Alert', 'Market News', 'AI Insight'];
    final type = types[index % 3];
    final icons = [Icons.trending_up_rounded, Icons.newspaper_rounded, Icons.auto_awesome_rounded];
    final colors = [AppColors.success, AppColors.primary, AppColors.accent];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors[index % 3].withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icons[index % 3], color: colors[index % 3], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Text('2h ago', style: TextStyle(color: AppColors.textTertiary, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getMockMessage(index),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMockMessage(int index) {
    final messages = [
      'Your BTC/USDT Long trade hit Take Profit 1. +2.4% ROI.',
      'High Impact News: US CPI data will be released in 30 minutes.',
      'AI Insight: You have a high win rate when trading the London open.',
      'Daily Drawdown Alert: You are nearing your 2% daily loss limit.',
    ];
    return messages[index % messages.length];
  }
}
