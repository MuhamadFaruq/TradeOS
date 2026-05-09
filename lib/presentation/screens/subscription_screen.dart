import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Upgrade to\nTradeOS Pro',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unlock institutional-grade analytics and AI-powered trading insights.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            _buildPriceCard(
              'Monthly',
              '\$29.99',
              'Per month, billed monthly.',
              false,
            ),
            const SizedBox(height: 20),
            _buildPriceCard(
              'Annual',
              '\$249.99',
              'Save 30%. Billed annually.',
              true,
            ),
            const SizedBox(height: 48),
            _buildFeaturesList(),
            const SizedBox(height: 48),
            GlowingButton(text: 'START 7-DAY FREE TRIAL', onPressed: () {}),
            const SizedBox(height: 24),
            const Text('Restore Purchases', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(String title, String price, String desc, bool isPopular) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: isPopular ? [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: -10),
        ] : [],
      ),
      child: GlassCard(
        borderColor: isPopular ? AppColors.primary.withValues(alpha: 0.5) : null,
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      if (isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('BEST VALUE', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Unlimited Trading Journal entries',
      'Advanced AI Trade Analysis',
      'Prop Firm Drawdown Monitoring',
      'Institutional Economic Calendar',
      'Strategy Backtesting Engine',
      'Cloud Sync across devices',
    ];

    return Column(
      children: features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(f, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      )).toList(),
    );
  }
}
