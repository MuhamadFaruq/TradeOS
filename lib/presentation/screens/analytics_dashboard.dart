import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';

class AnalyticsDashboard extends ConsumerWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: AppColors.background,
            pinned: true,
            title: Text('Performance Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildEquitySection(context, trades.length, notifier.winRate, notifier.profitFactor),
                const SizedBox(height: 30),
                _buildPnLHeatmap(context, trades),
                const SizedBox(height: 30),
                _buildSessionAnalytics(context),
                const SizedBox(height: 30),
                _buildSetupBreakdown(context, trades),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquitySection(BuildContext context, int count, double winRate, double pf) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Equity Curve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: DetailedChartPainter()),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat('Total Trades', count.toString()),
              _buildSimpleStat('Win Rate', '${winRate.toStringAsFixed(1)}%'),
              _buildSimpleStat('Profit Factor', pf.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildPnLHeatmap(BuildContext context, List<dynamic> trades) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PnL Heatmap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((e) => Text(e, style: const TextStyle(color: AppColors.textTertiary))).toList(),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 35,
                itemBuilder: (context, index) {
                  // Simply mock some colors for now but based on index parity for visual interest
                  Color color;
                  if (index % 5 == 0) {
                    color = AppColors.success.withValues(alpha: 0.8);
                  } else if (index % 7 == 0) color = AppColors.danger.withValues(alpha: 0.6);
                  else color = Colors.white.withValues(alpha: 0.05);
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionAnalytics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Session Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        _buildSessionRow('London Session', 0.75),
        const SizedBox(height: 12),
        _buildSessionRow('New York Session', 0.42),
        const SizedBox(height: 12),
        _buildSessionRow('Asian Session', 0.15),
      ],
    );
  }

  Widget _buildSessionRow(String name, double performance) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name),
              Text('${(performance * 100).toInt()}% Win Rate', style: TextStyle(color: performance > 0.5 ? AppColors.success : AppColors.danger)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: performance,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(performance > 0.5 ? AppColors.success : AppColors.danger),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildSetupBreakdown(BuildContext context, List<dynamic> trades) {
    // Group trades by strategy
    final Map<String, double> strategyPnL = {};
    for (var trade in trades) {
      final strategy = trade.strategy ?? 'Unknown';
      strategyPnL[strategy] = (strategyPnL[strategy] ?? 0) + trade.pnl;
    }

    final strategies = strategyPnL.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Setup ROI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        if (strategies.isEmpty)
          const Center(child: Text('No strategy data yet.', style: TextStyle(color: AppColors.textTertiary)))
        else
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: strategies.length,
              itemBuilder: (context, index) {
                final entry = strategies[index];
                return _buildSetupCard(entry.key, '${entry.value >= 0 ? '+' : ''}\$${entry.value.toStringAsFixed(0)}', entry.value >= 0 ? AppColors.success : AppColors.danger);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSetupCard(String name, String pnl, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 12),
            Text(pnl, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class DetailedChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primary.withValues(alpha: 0.3), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.lineTo(size.width * 0.1, size.height * 0.85);
    path.lineTo(size.width * 0.2, size.height * 0.95);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.55);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width * 0.9, size.height * 0.1);
    path.lineTo(size.width, size.height * 0.15);

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
