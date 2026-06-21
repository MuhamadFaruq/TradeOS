import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';
import '../../core/services/gemini_service.dart';
import 'ai_insights_screen.dart';

class WeeklyReviewScreen extends ConsumerStatefulWidget {
  const WeeklyReviewScreen({super.key});

  @override
  ConsumerState<WeeklyReviewScreen> createState() => _WeeklyReviewScreenState();
}

class _WeeklyReviewScreenState extends ConsumerState<WeeklyReviewScreen> {
  String? _latestReport;
  bool _loadingReport = true;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    try {
      final report = await GeminiService.getLatestReport();
      setState(() {
        _latestReport = report;
        _loadingReport = false;
      });
    } catch (_) {
      setState(() {
        _loadingReport = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);
    final disciplineRate = notifier.disciplineRate;
    final mistakeCosts = notifier.mistakeCosts;
    
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
            _buildWeeklySummaryCard(notifier.totalPnL, notifier.winRate, disciplineRate, mistakeCosts),
            const SizedBox(height: 32),
            _buildLabel('AI Coach Insights'),
            const SizedBox(height: 16),
            if (trades.isEmpty)
              const Center(child: Text('No data for review yet.', style: TextStyle(color: AppColors.textTertiary)))
            else if (_loadingReport)
              const Center(child: CircularProgressIndicator(color: AppColors.primary))
            else if (_latestReport != null) ...[
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: MarkdownRenderer(text: _latestReport!),
              ),
              const SizedBox(height: 24),
            ] else ...[
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.psychology_rounded, color: AppColors.primary, size: 40),
                    const SizedBox(height: 16),
                    const Text(
                      'AI Coach Belum Siap',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Jalankan sesi mingguan di modul AI Coach untuk mendapatkan analisis perilaku trading, metrik kesalahan, dan rencana tindakan dari AI.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AIInsightsScreen()),
                        ).then((_) => _loadReport()); // Reload report when coming back
                      },
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: const Text('SESI AI COACH'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            _buildLabel('Action Plan for Next Week'),
            const SizedBox(height: 16),
            const GlassCard(
              enableBlur: false,
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

  Widget _buildWeeklySummaryCard(double pnl, double winRate, double disciplineRate, double mistakeCosts) {
    return GlassCard(
      enableBlur: false,
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
              _buildMetric('Discipline', '${(disciplineRate / 10).toStringAsFixed(1)}/10', AppColors.accent),
            ],
          ),
          if (mistakeCosts > 0) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mistake Costs (Biaya Kesalahan):', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text(
                  '-\$${mistakeCosts.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ],
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: isCompleted ? Colors.white : AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
