import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';
import '../../data/models/trade.dart';

class AnalyticsDashboard extends ConsumerWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);

    // Calculate real equity and disciplined equity curve data points
    final sortedTrades = List<Trade>.from(trades)..sort((a, b) => a.date.compareTo(b.date));
    
    final List<double> realEquity = [0.0];
    final List<double> discEquity = [0.0];
    
    for (var trade in sortedTrades) {
      realEquity.add(realEquity.last + trade.pnl);
      discEquity.add(discEquity.last + (trade.wasRuleBroken ? 0.0 : trade.pnl));
    }

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: AppColors.background,
              pinned: true,
              title: Text('Performance Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Overall'),
                  Tab(text: 'Long vs Short'),
                ],
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textTertiary,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: TabBarView(
                      children: [
                        // Tab 1: Overall Stats
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildEquitySection(
                                context, 
                                trades.length, 
                                notifier.winRate, 
                                notifier.profitFactor,
                                notifier.disciplineRate,
                                notifier.mistakeCosts,
                                realEquity,
                                discEquity,
                              ),
                              const SizedBox(height: 30),
                              _buildPnLHeatmap(context, trades),
                              const SizedBox(height: 30),
                              _buildSessionAnalytics(context),
                              const SizedBox(height: 30),
                              _buildSetupBreakdown(context, trades),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                        // Tab 2: Long vs Short Comparison
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildLongVsShortComparison(context, notifier),
                              const SizedBox(height: 30),
                              _buildDirectionBreakdown(context, notifier),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquitySection(
    BuildContext context, 
    int count, 
    double winRate, 
    double pf, 
    double disciplineRate, 
    double mistakeCosts,
    List<double> realEquity,
    List<double> discEquity,
  ) {
    return GlassCard(
      enableBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Equity Curve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 3,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  const Text('Real', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                  const SizedBox(width: 12),
                  Container(
                    width: 12,
                    height: 3,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  const Text('Disciplined', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: DetailedChartPainter(
                  realEquity: realEquity,
                  discEquity: discEquity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat('Total Trades', count.toString()),
              _buildSimpleStat('Win Rate', '${winRate.toStringAsFixed(1)}%'),
              _buildSimpleStat('Profit Factor', pf.isInfinite ? '∞' : pf.toStringAsFixed(2)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat(
                'Discipline Rate', 
                '${disciplineRate.toStringAsFixed(1)}%', 
                disciplineRate >= 70 ? AppColors.success : AppColors.warning,
              ),
              _buildSimpleStat(
                'Mistake Costs', 
                '-\$${mistakeCosts.toStringAsFixed(2)}', 
                mistakeCosts > 0 ? AppColors.danger : AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLongVsShortComparison(BuildContext context, dynamic notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Position Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                enableBlur: false,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('LONG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildComparisonStat('Trades', '${notifier.longTradeCount}'),
                    const SizedBox(height: 8),
                    _buildComparisonStat('Win Rate', '${notifier.longWinRate.toStringAsFixed(1)}%'),
                    const SizedBox(height: 8),
                    _buildComparisonStat('Profit Factor', notifier.longProfitFactor.toStringAsFixed(2)),
                    const SizedBox(height: 8),
                    _buildComparisonStat('P&L', '\$${notifier.longTotalPnL.toStringAsFixed(0)}',
                        notifier.longTotalPnL >= 0 ? AppColors.success : AppColors.danger),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                enableBlur: false,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('SHORT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildComparisonStat('Trades', '${notifier.shortTradeCount}'),
                    const SizedBox(height: 8),
                    _buildComparisonStat('Win Rate', '${notifier.shortWinRate.toStringAsFixed(1)}%'),
                    const SizedBox(height: 8),
                    _buildComparisonStat('Profit Factor', notifier.shortProfitFactor.toStringAsFixed(2)),
                    const SizedBox(height: 8),
                    _buildComparisonStat('P&L', '\$${notifier.shortTotalPnL.toStringAsFixed(0)}',
                        notifier.shortTotalPnL >= 0 ? AppColors.success : AppColors.danger),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectionBreakdown(BuildContext context, dynamic notifier) {
    final longCount = notifier.longTradeCount;
    final shortCount = notifier.shortTradeCount;
    final total = longCount + shortCount;

    if (total == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No trades yet', style: TextStyle(color: AppColors.textTertiary)),
        ),
      );
    }

    final longPercent = (longCount / total) * 100;
    final shortPercent = (shortCount / total) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Position Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        GlassCard(
          enableBlur: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Long Trades'),
                  Text('${longPercent.toStringAsFixed(1)}%',
                      style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: longPercent / 100,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Short Trades'),
                  Text('${shortPercent.toStringAsFixed(1)}%',
                      style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: shortPercent / 100,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.danger),
                borderRadius: BorderRadius.circular(10),
                minHeight: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonStat(String label, String value, [Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            )),
      ],
    );
  }

  Widget _buildSimpleStat(String label, String value, [Color? color]) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 16,
            color: color ?? Colors.white,
          ),
        ),
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
          enableBlur: false,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((e) => Text(e, style: const TextStyle(color: AppColors.textTertiary))).toList(),
              ),
              const SizedBox(height: 12),
              RepaintBoundary(
                child: GridView.builder(
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
      enableBlur: false,
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
        enableBlur: false,
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
  final List<double> realEquity;
  final List<double> discEquity;

  DetailedChartPainter({required this.realEquity, required this.discEquity});

  @override
  void paint(Canvas canvas, Size size) {
    if (realEquity.isEmpty) return;

    double maxVal = realEquity.first;
    double minVal = realEquity.first;
    
    for (var val in realEquity) {
      if (val > maxVal) maxVal = val;
      if (val < minVal) minVal = val;
    }
    for (var val in discEquity) {
      if (val > maxVal) maxVal = val;
      if (val < minVal) minVal = val;
    }

    double range = maxVal - minVal;
    if (range == 0) range = 10.0;
    
    final double padMax = maxVal + range * 0.15;
    final double padMin = minVal - range * 0.15;

    double priceToY(double val) {
      return size.height - 20 - ((val - padMin) / (padMax - padMin)) * (size.height - 40);
    }

    double indexToX(int idx, int total) {
      if (total <= 1) return size.width / 2;
      return (size.width - 20) * (idx / (total - 1)) + 10;
    }

    // 1. Draw Real Equity curve (Solid line)
    final realPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final realPath = Path();
    realPath.moveTo(indexToX(0, realEquity.length), priceToY(realEquity.first));
    for (int i = 1; i < realEquity.length; i++) {
      realPath.lineTo(indexToX(i, realEquity.length), priceToY(realEquity[i]));
    }
    canvas.drawPath(realPath, realPaint);

    // Draw Fill under Real Equity
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primary.withValues(alpha: 0.15), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final fillPath = Path.from(realPath);
    fillPath.lineTo(indexToX(realEquity.length - 1, realEquity.length), size.height);
    fillPath.lineTo(indexToX(0, realEquity.length), size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // 2. Draw Disciplined Equity curve (Dashed line in green)
    final discColor = AppColors.success;
    final discPaint = Paint()
      ..color = discColor.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final discPath = Path();
    discPath.moveTo(indexToX(0, discEquity.length), priceToY(discEquity.first));
    for (int i = 1; i < discEquity.length; i++) {
      discPath.lineTo(indexToX(i, discEquity.length), priceToY(discEquity[i]));
    }
    
    _drawDashedPath(canvas, discPath, discPaint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      const double dashLength = 5.0;
      const double gapLength = 3.0;
      while (distance < metric.length) {
        final double end = (distance + dashLength).clamp(0.0, metric.length);
        final Path extract = metric.extractPath(distance, end);
        canvas.drawPath(extract, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DetailedChartPainter oldDelegate) {
    return oldDelegate.realEquity != realEquity || oldDelegate.discEquity != discEquity;
  }
}
