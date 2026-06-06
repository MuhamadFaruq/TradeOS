import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';

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
  double _sliderPosition = 0.5; // 0 = Before, 1 = After
  bool _showBeforeChart = true;

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
            setState(() => _currentCandle++);
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
    final hasBeforeScreenshots = widget.trade?.beforeEntryScreenshots?.isNotEmpty ?? false;
    final hasAfterScreenshots = widget.trade?.afterExitScreenshots?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Trade Replay', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
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
            // Mock Candle Chart
            RepaintBoundary(
              child: CustomPaint(
                painter: ReplayChartPainter(candles: _currentCandle),
                child: Container(),
              ),
            ),

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
            if (widget.trade != null)
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
                        '${widget.trade!.pair} ${widget.trade!.direction.name.toUpperCase()}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'P&L: ${widget.trade!.pnl >= 0 ? '+' : ''}\$${widget.trade!.pnl.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: widget.trade!.pnl >= 0 ? AppColors.success : AppColors.danger,
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
              onPressed: () => setState(() => _currentCandle = (_currentCandle - 1).clamp(0, 100)),
            ),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
              iconSize: 48,
              color: AppColors.primary,
              onPressed: _togglePlay,
            ),
            IconButton(
              icon: const Icon(Icons.forward_10_rounded),
              onPressed: () => setState(() => _currentCandle = (_currentCandle + 1).clamp(0, 100)),
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
                      clipper: _SliderClipper(_sliderPosition),
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

                    // SLIDER HANDLE
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.8 * _sliderPosition - 15,
                      top: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final RenderBox box = context.findRenderObject() as RenderBox;
                          final localOffset = box.globalToLocal(details.globalPosition);
                          setState(() {
                            _sliderPosition = (localOffset.dx / box.size.width).clamp(0.0, 1.0);
                          });
                        },
                        child: Container(
                          width: 30,
                          color: Colors.transparent,
                          child: Center(
                            child: Container(
                              width: 2,
                              height: double.infinity,
                              color: AppColors.primary,
                            ),
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
          const SizedBox(height: 12),
          Slider(
            value: _sliderPosition,
            min: 0.0,
            max: 1.0,
            activeColor: AppColors.primary,
            onChanged: (value) => setState(() => _sliderPosition = value),
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
          if (widget.trade != null && widget.trade!.cvd != null)
            ...[
              const SizedBox(height: 12),
              _buildAnalysisItem(
                'Order Flow Analysis',
                'CVD: ${widget.trade!.cvd!.toStringAsFixed(2)} - ${widget.trade!.hasCVDAnomaly() ? "⚠️ ANOMALY DETECTED" : "Normal range"}',
                widget.trade!.hasCVDAnomaly() ? AppColors.warning : AppColors.success,
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

class ReplayChartPainter extends CustomPainter {
  final int candles;
  ReplayChartPainter({required this.candles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2;

    for (int i = 0; i < candles; i++) {
      final x = (size.width / 100) * i + 10;
      final isUp = i % 3 != 0;
      paint.color = isUp ? AppColors.success.withValues(alpha: 0.5) : AppColors.danger.withValues(alpha: 0.5);

      final h = 20.0 + (i % 5) * 10;
      final y = size.height / 2 + (isUp ? -h : 0);

      canvas.drawRect(Rect.fromLTWH(x, y, 6, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SliderClipper extends CustomClipper<Rect> {
  final double position;
  _SliderClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) => oldClipper.position != position;
}
