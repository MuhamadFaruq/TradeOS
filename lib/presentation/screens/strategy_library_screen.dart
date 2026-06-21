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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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
                onPressed: () => _showRulesBottomSheet(context, name),
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

  void _showRulesBottomSheet(BuildContext context, String name) {
    List<Map<String, String>> rules = [];
    
    if (name.contains('Bull Flag')) {
      rules = [
        {'label': 'MARKET SETUP', 'desc': 'Identifikasi pergerakan tren naik yang kuat (impulsive move), diikuti oleh fase konsolidasi menurun yang teratur (flag/channel).'},
        {'label': 'ENTRY CRITERIA', 'desc': 'Masuk posisi Buy (Long) saat harga menembus (breakout) batas atas channel bendera dengan volume yang meningkat.'},
        {'label': 'STOP LOSS', 'desc': 'Letakkan SL tepat di bawah titik terendah dari struktur bendera (flag low).'},
        {'label': 'TAKE PROFIT', 'desc': 'Target minimum 1:2.5 Risk-to-Reward ratio, atau diukur dari tinggi tiang bendera.'},
      ];
    } else if (name.contains('Mean Reversion')) {
      rules = [
        {'label': 'MARKET SETUP', 'desc': 'Harga bergerak sangat jauh dari nilai rata-rata volume tertimbang (VWAP) hingga menyentuh atau melewati Standard Deviation Band ke-2 atau ke-3.'},
        {'label': 'ENTRY CRITERIA', 'desc': 'Masuk posisi Sell (Short) jika harga di atas SD Band +2 dan menunjukkan pola pembalikan arah (candlestick reversal), atau sebaliknya untuk posisi Buy (Long).'},
        {'label': 'STOP LOSS', 'desc': 'Letakkan SL di atas/bawah titik tertinggi atau terendah lokal terakhir (swing high/low).'},
        {'label': 'TAKE PROFIT', 'desc': 'Target utama adalah harga kembali menyentuh garis tengah VWAP (mean reversion).'},
      ];
    } else {
      rules = [
        {'label': 'MARKET SETUP', 'desc': 'Identifikasi level resistance kuat yang telah berhasil ditembus oleh harga (broken resistance).'},
        {'label': 'ENTRY CRITERIA', 'desc': 'Masuk posisi Buy (Long) ketika harga kembali turun melakukan pengujian ulang (retest) pada level yang ditembus tersebut (kini berfungsi sebagai Support baru).'},
        {'label': 'STOP LOSS', 'desc': 'Letakkan SL beberapa pips di bawah level Support baru tersebut.'},
        {'label': 'TAKE PROFIT', 'desc': 'Target minimum 1:2.0 Risk-to-Reward ratio ke level resistance terdekat berikutnya.'},
      ];
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.98),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.surface.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STRATEGY RULES',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              ...rules.map((rule) {
                final label = rule['label']!;
                final desc = rule['desc']!;
                
                IconData icon;
                Color iconColor;
                if (label.contains('SETUP')) {
                  icon = Icons.grid_view_rounded;
                  iconColor = AppColors.primary;
                } else if (label.contains('ENTRY')) {
                  icon = Icons.login_rounded;
                  iconColor = AppColors.success;
                } else if (label.contains('LOSS')) {
                  icon = Icons.gpp_bad_rounded;
                  iconColor = AppColors.danger;
                } else {
                  icon = Icons.verified_rounded;
                  iconColor = AppColors.accent;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: iconColor, size: 18),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              desc,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              GlowingButton(
                text: 'CLOSE RULES',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
