import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import '../../data/providers/trade_provider.dart';

class TradeReplayScreen extends ConsumerStatefulWidget {
  final Trade? trade;

  const TradeReplayScreen({super.key, this.trade});

  @override
  ConsumerState<TradeReplayScreen> createState() => _TradeReplayScreenState();
}

class _TradeReplayScreenState extends ConsumerState<TradeReplayScreen> {
  int _currentCandle = 5;
  bool _isPlaying = false;
  Timer? _timer;
  late List<CandleData> _candles;
  late final WebViewController _controller;
  bool _isChartReady = false;
  Trade? _activeTrade;

  @override
  void initState() {
    super.initState();
    _activeTrade = widget.trade;
    _candles = _generateProceduralCandles(_activeTrade);
    _initWebViewController();
  }

  void _initWebViewController() {
    final htmlContent = """
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <script src="https://cdn.jsdelivr.net/npm/lightweight-charts@5.2.0/dist/lightweight-charts.standalone.production.js"></script>
  <style>
    body, html {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background-color: #0F172A;
      overflow: hidden;
    }
    #chart {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div id="chart"></div>
  <script>
    let chart;
    let candleSeries;
    let allCandles = [];
    let slLine = null;
    let tpLine = null;
    let entryLine = null;
    let exitLine = null;
    let entryPrice = null;
    let exitPrice = null;
    let slValue = null;
    let tpValue = null;
    let isLong = true;

    chart = LightweightCharts.createChart(document.getElementById('chart'), {
      width: window.innerWidth,
      height: window.innerHeight,
      layout: {
        background: { type: 'solid', color: '#0F172A' },
        textColor: '#94a3b8',
      },
      grid: {
        vertLines: { color: 'rgba(255, 255, 255, 0.05)' },
        horzLines: { color: 'rgba(255, 255, 255, 0.05)' },
      },
      crosshair: {
        mode: LightweightCharts.CrosshairMode.Normal,
      },
      rightPriceScale: {
        borderColor: 'rgba(255, 255, 255, 0.1)',
      },
      timeScale: {
        borderColor: 'rgba(255, 255, 255, 0.1)',
      },
    });

    candleSeries = chart.addCandlestickSeries({
      upColor: '#10b981',
      downColor: '#fb7185',
      borderUpColor: '#10b981',
      borderDownColor: '#fb7185',
      wickUpColor: '#10b981',
      wickDownColor: '#fb7185',
    });

    window.setChartData = function(data) {
      allCandles = data.candles;
      slValue = data.sl;
      tpValue = data.tp;
      entryPrice = data.entry;
      exitPrice = data.exit;
      isLong = data.isLong;
      
      if (slValue) {
        slLine = candleSeries.createPriceLine({
          price: slValue,
          color: '#fb7185',
          lineWidth: 1.5,
          lineStyle: LightweightCharts.LineStyle.Dashed,
          axisLabelVisible: true,
          title: 'SL: ' + slValue.toFixed(2),
        });
      }
      if (tpValue) {
        tpLine = candleSeries.createPriceLine({
          price: tpValue,
          color: '#10b981',
          lineWidth: 1.5,
          lineStyle: LightweightCharts.LineStyle.Dashed,
          axisLabelVisible: true,
          title: 'TP: ' + tpValue.toFixed(2),
        });
      }

      window.updateVisibleCount(data.visibleCount || 5);
    };

    window.updateVisibleCount = function(count) {
      const visibleCandles = allCandles.slice(0, count);
      candleSeries.setData(visibleCandles);
      
      // Dynamic Entry Line
      if (count >= 20 && entryPrice) {
        if (!entryLine) {
          entryLine = candleSeries.createPriceLine({
            price: entryPrice,
            color: '#3b82f6',
            lineWidth: 1.5,
            lineStyle: LightweightCharts.LineStyle.Solid,
            axisLabelVisible: true,
            title: 'ENTRY: ' + entryPrice.toFixed(2),
          });
        }
      } else {
        if (entryLine) {
          candleSeries.removePriceLine(entryLine);
          entryLine = null;
        }
      }

      // Dynamic Exit Line
      if (count >= 80 && exitPrice) {
        if (!exitLine) {
          exitLine = candleSeries.createPriceLine({
            price: exitPrice,
            color: '#fbbf24',
            lineWidth: 1.5,
            lineStyle: LightweightCharts.LineStyle.Solid,
            axisLabelVisible: true,
            title: 'EXIT: ' + exitPrice.toFixed(2),
          });
        }
      } else {
        if (exitLine) {
          candleSeries.removePriceLine(exitLine);
          exitLine = null;
        }
      }

      // Update Markers
      const markers = [];
      if (count >= 20 && allCandles.length > 20) {
        markers.push({
          time: allCandles[20].time,
          position: isLong ? 'belowBar' : 'aboveBar',
          color: '#3b82f6',
          shape: isLong ? 'arrowUp' : 'arrowDown',
          text: 'ENTRY',
        });
      }
      if (count >= 80 && allCandles.length > 80) {
        markers.push({
          time: allCandles[80].time,
          position: isLong ? 'aboveBar' : 'belowBar',
          color: '#fbbf24',
          shape: isLong ? 'arrowDown' : 'arrowUp',
          text: 'EXIT',
        });
      }
      candleSeries.setMarkers(markers);
    };

    window.addEventListener('resize', () => {
      chart.resize(window.innerWidth, window.innerHeight);
    });
  </script>
</body>
</html>
""";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.cardBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isChartReady = true;
            });
            _sendInitialData();
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            if (request.isMainFrame && (url.startsWith('http://') || url.startsWith('https://'))) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  void _sendInitialData() {
    if (!_isChartReady) return;

    final entry = _activeTrade?.entryPrice ?? 100.0;
    final exit = _activeTrade?.exitPrice ?? (_activeTrade?.pnl != null ? entry + (_activeTrade!.pnl >= 0 ? 5.0 : -5.0) : 105.0);
    final isLong = _activeTrade == null || _activeTrade!.direction == TradeDirection.long;
    final sl = _activeTrade?.stopLossPrice ?? (isLong ? entry - 10.0 : entry + 10.0);
    final tp = _activeTrade?.takeProfitPrice ?? (isLong ? entry + 15.0 : entry - 15.0);

    final payload = {
      'candles': _candles.map((c) => c.toJson()).toList(),
      'sl': sl,
      'tp': tp,
      'entry': entry,
      'exit': exit,
      'isLong': isLong,
      'visibleCount': _currentCandle,
    };

    _controller.runJavaScript("window.setChartData(${json.encode(payload)})");
  }

  void _updateChartCount(int count) {
    if (_isChartReady) {
      _controller.runJavaScript("window.updateVisibleCount($count)");
    }
  }

  List<CandleData> _generateProceduralCandles(Trade? trade) {
    final List<CandleData> list = [];
    
    // Set up price references
    final double entry = trade?.entryPrice ?? 100.0;
    final double exit = trade?.exitPrice ?? (trade?.pnl != null ? entry + (trade!.pnl >= 0 ? 5.0 : -5.0) : 105.0);
    final bool isLong = trade == null || trade.direction == TradeDirection.long;
    
    // Fallbacks for high/low
    final double high = trade?.highPrice ?? (isLong ? (exit > entry ? exit + 2.0 : entry + 3.0) : (entry > exit ? entry + 2.0 : exit + 3.0));
    final double low = trade?.lowPrice ?? (isLong ? (entry < exit ? entry - 3.0 : exit - 2.0) : (exit < entry ? exit - 3.0 : entry - 2.0));

    final List<double> prices = List.generate(100, (index) => 0.0);

    // Segment 1: Index 0..20: Before trade (approaching entry)
    final double beforeStart = entry - (isLong ? 8.0 : -8.0);
    for (int i = 0; i <= 20; i++) {
      final double t = i / 20.0;
      final double noise = (i % 3 - 1) * 0.4;
      prices[i] = beforeStart + (entry - beforeStart) * t + noise;
    }

    // Segment 2: Index 21..80: Active trade (moving from entry to exit, hitting high/low)
    final double midDrawdown = isLong ? low + 1.0 : high - 1.0;
    final double midGain = isLong ? high - 0.5 : low + 0.5;

    for (int i = 21; i <= 45; i++) {
      final double t = (i - 20) / 25.0;
      final double noise = (i % 4 - 1.5) * 0.3;
      prices[i] = entry + (midDrawdown - entry) * t + noise;
    }

    for (int i = 46; i <= 65; i++) {
      final double t = (i - 45) / 20.0;
      final double noise = (i % 3 - 1) * 0.2;
      prices[i] = midDrawdown + (midGain - midDrawdown) * t + noise;
    }

    for (int i = 66; i <= 80; i++) {
      final double t = (i - 65) / 15.0;
      final double noise = (i % 5 - 2) * 0.15;
      prices[i] = midGain + (exit - midGain) * t + noise;
    }

    // Segment 3: Index 81..99: After trade (oscillating around exit)
    for (int i = 81; i < 100; i++) {
      final double noise = (i % 4 - 1.5) * 0.4;
      prices[i] = exit + noise;
    }

    final baseDate = DateTime(2026, 6, 21);

    // Convert prices to CandleData
    for (int i = 0; i < 100; i++) {
      final double close = prices[i];
      final double open = i == 0 ? close - 0.5 : prices[i - 1];
      
      double cHigh = close > open ? close + 0.3 : open + 0.3;
      double cLow = close < open ? close - 0.3 : open - 0.3;

      if (i == 55) {
        cHigh = high;
      }
      if (i == 35) {
        cLow = low;
      }
      
      final double finalHigh = cHigh.clamp(low - 0.5, high + 0.5);
      final double finalLow = cLow.clamp(low - 0.5, high + 0.5);

      final candleDate = baseDate.add(Duration(days: i));
      final dateString = "${candleDate.year}-${candleDate.month.toString().padLeft(2, '0')}-${candleDate.day.toString().padLeft(2, '0')}";

      list.add(CandleData(
        time: dateString,
        open: open,
        high: finalHigh,
        low: finalLow,
        close: close,
      ));
    }

    return list;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (_currentCandle < 100) {
            setState(() {
              _currentCandle++;
            });
            _updateChartCount(_currentCandle);
          } else {
            _togglePlay();
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradeProvider);

    if (_activeTrade == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Trade untuk Replay', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: trades.isEmpty
            ? const Center(
                child: Text('Belum ada data trade untuk direplay.', style: TextStyle(color: AppColors.textTertiary)),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: trades.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final trade = trades[index];
                  final isWon = trade.status == TradeStatus.won;
                  final statusColor = isWon ? AppColors.success : AppColors.danger;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeTrade = trade;
                        _candles = _generateProceduralCandles(trade);
                        _isChartReady = false;
                      });
                      _initWebViewController();
                    },
                    child: GlassCard(
                      enableBlur: false,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              trade.direction == TradeDirection.long ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trade.pair, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(
                                  '${trade.direction.name.toUpperCase()} • ${trade.strategy ?? "No Strategy"}',
                                  style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${trade.pnl >= 0 ? '+' : ''}\$${trade.pnl.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM yyyy').format(trade.date),
                                style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      );
    }

    final hasBeforeScreenshots = _activeTrade?.beforeEntryScreenshots?.isNotEmpty ?? false;
    final hasAfterScreenshots = _activeTrade?.afterExitScreenshots?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Trade Replay', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Ganti Trade',
            onPressed: () {
              setState(() {
                _activeTrade = null;
                _isChartReady = false;
              });
            },
          ),
          if (hasBeforeScreenshots || hasAfterScreenshots)
            IconButton(
              icon: const Icon(Icons.image_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening chart screenshots...')),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildChartReplayArea(),
          ),
          _buildReplayControls(),
          if (hasBeforeScreenshots || hasAfterScreenshots)
            _buildImageComparisonSlider(context, hasBeforeScreenshots, hasAfterScreenshots),
          Expanded(
            flex: 2,
            child: _buildReplayAnalysis(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartReplayArea() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // TradingView Lightweight Charts WebView
            WebViewWidget(controller: _controller),

            // Replay Overlay
            Positioned(
              top: 20,
              right: 20,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'CANDLE $_currentCandle/100',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),

            // Trade Info Overlay
            if (_activeTrade != null)
              Positioned(
                bottom: 20,
                left: 20,
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_activeTrade!.pair} ${_activeTrade!.direction.name.toUpperCase()}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'P&L: ${_activeTrade!.pnl >= 0 ? '+' : ''}\$${_activeTrade!.pnl.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: _activeTrade!.pnl >= 0 ? AppColors.success : AppColors.danger,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplayControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10_rounded),
              onPressed: () {
                setState(() {
                  _currentCandle = (_currentCandle - 10).clamp(0, 100);
                });
                _updateChartCount(_currentCandle);
              },
            ),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
              iconSize: 48,
              color: AppColors.primary,
              onPressed: _togglePlay,
            ),
            IconButton(
              icon: const Icon(Icons.forward_10_rounded),
              onPressed: () {
                setState(() {
                  _currentCandle = (_currentCandle + 10).clamp(0, 100);
                });
                _updateChartCount(_currentCandle);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageComparisonSlider(BuildContext context, bool hasBefore, bool hasAfter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Before/After Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // AFTER IMAGE (Background)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white.withValues(alpha: 0.05),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_search_rounded, color: AppColors.primary, size: 48),
                            SizedBox(height: 8),
                            Text('AFTER EXIT CHART', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                          ],
                        ),
                      ),
                    ),
                    
                    // BEFORE IMAGE (Clipping overlay)
                    ClipRect(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary, size: 48),
                              SizedBox(height: 8),
                              Text('BEFORE ENTRY CHART', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // LABELS
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _buildLabelBadge('BEFORE', AppColors.primary),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _buildLabelBadge('AFTER', AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildReplayAnalysis() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Replay Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          _buildAnalysisItem(
            'Entry Timing',
            'You entered 2 candles too early. Waiting for H1 close would have reduced drawdown.',
            AppColors.warning,
          ),
          const SizedBox(height: 12),
          _buildAnalysisItem(
            'Exit Discipline',
            'Perfect exit at 2nd deviation. You avoided the reversal.',
            AppColors.success,
          ),
          if (_activeTrade != null && _activeTrade!.cvd != null)
            ...[
              const SizedBox(height: 12),
              _buildAnalysisItem(
                'Order Flow Analysis',
                'CVD: ${_activeTrade!.cvd!.toStringAsFixed(2)} - ${_activeTrade!.hasCVDAnomaly() ? "⚠️ ANOMALY DETECTED" : "Normal range"}',
                _activeTrade!.hasCVDAnomaly() ? AppColors.warning : AppColors.success,
              ),
            ],
          const SizedBox(height: 24),
          GlowingButton(text: 'SAVE LEARNED LESSON', onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lesson saved to your learning journal!')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(String title, String desc, Color color) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CandleData {
  final String time;
  final double open;
  final double high;
  final double low;
  final double close;

  const CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  Map<String, dynamic> toJson() => {
    'time': time,
    'open': open,
    'high': high,
    'low': low,
    'close': close,
  };
}
