import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class TradeReplayScreen extends StatefulWidget {
  const TradeReplayScreen({super.key});

  @override
  State<TradeReplayScreen> createState() => _TradeReplayScreenState();
}

class _TradeReplayScreenState extends State<TradeReplayScreen> {
  int _currentCandle = 5;
  bool _isPlaying = false;
  Timer? _timer;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Trade Replay', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_input_component_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Replay settings coming soon...')),
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
            CustomPaint(
              painter: ReplayChartPainter(candles: _currentCandle),
              child: Container(),
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
