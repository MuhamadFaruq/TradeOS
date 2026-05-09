import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import '../../data/providers/trade_provider.dart';

class AddTradeScreen extends ConsumerStatefulWidget {
  const AddTradeScreen({super.key});

  @override
  ConsumerState<AddTradeScreen> createState() => _AddTradeScreenState();
}

class _AddTradeScreenState extends ConsumerState<AddTradeScreen> {
  String _direction = 'LONG';
  final String _session = 'LONDON';
  final String _emotion = 'CALM';
  double _confidence = 5.0;
  
  final _pairController = TextEditingController(text: 'BTC/USDT');
  final _strategyController = TextEditingController(text: 'Bull Flag');
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _amountController = TextEditingController();
  final _leverageController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _pairController.dispose();
    _strategyController.dispose();
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _amountController.dispose();
    _leverageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveTrade() {
    final entryPrice = double.tryParse(_entryPriceController.text) ?? 0.0;
    final exitPrice = double.tryParse(_exitPriceController.text) ?? 0.0;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final leverage = double.tryParse(_leverageController.text) ?? 1.0;
    
    // PnL calculation for Futures: ((Exit - Entry) / Entry) * Margin * Leverage
    final pnl = entryPrice != 0 
      ? ((exitPrice - entryPrice) / entryPrice) * amount * leverage * (_direction == 'LONG' ? 1 : -1)
      : 0.0;
    
    final pnlPercentage = amount != 0 ? (pnl / amount) * 100 : 0.0;
    
    final trade = Trade.create(
      pair: _pairController.text,
      direction: _direction == 'LONG' ? TradeDirection.long : TradeDirection.short,
      entryPrice: entryPrice,
      exitPrice: exitPrice,
      amount: amount,
      pnl: pnl,
      pnlPercentage: pnlPercentage,
      status: pnl >= 0 ? TradeStatus.won : TradeStatus.lost,
      date: DateTime.now(),
      strategy: _strategyController.text,
      notes: _notesController.text,
      emotion: _emotion,
      session: _session,
      confidence: _confidence.toInt(),
    );
    
    trade.leverage = leverage;
    trade.isLong = _direction == 'LONG';

    ref.read(tradeProvider.notifier).addTrade(trade);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('New Trade', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Direction Toggle
            Row(
              children: [
                Expanded(child: _buildDirectionTab('LONG', AppColors.success)),
                const SizedBox(width: 16),
                Expanded(child: _buildDirectionTab('SHORT', AppColors.danger)),
              ],
            ),
            const SizedBox(height: 32),
            
            _buildLabel('Trading Pair & Setup'),
            Row(
              children: [
                Expanded(child: _buildInputField('Pair (e.g. BTC/USDT)', controller: _pairController)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Strategy', controller: _strategyController)),
              ],
            ),
            
            const SizedBox(height: 24),
            _buildLabel('Entry Details'),
            Row(
              children: [
                Expanded(child: _buildInputField('Entry Price', controller: _entryPriceController)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Exit Price', controller: _exitPriceController)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('Margin Amount (\$)', controller: _amountController)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Leverage (x)', controller: _leverageController)),
              ],
            ),
            
            const SizedBox(height: 24),
            _buildLabel('Risk Management'),
            Row(
              children: [
                Expanded(child: _buildInputField('Stop Loss')),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Take Profit')),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildLabel('Session & Psychology'),
            Row(
              children: [
                Expanded(child: _buildSelectorField(_session, Icons.schedule_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildSelectorField(_emotion, Icons.sentiment_satisfied_rounded)),
              ],
            ),
            const SizedBox(height: 24),
            _buildLabel('Confidence Level: ${_confidence.toInt()}/10'),
            Slider(
              value: _confidence,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _confidence = v),
            ),
            
            const SizedBox(height: 32),
            _buildLabel('Mistakes (If any)'),
            _buildSelectorField('None / Stuck to Plan', Icons.report_problem_rounded),
            
            const SizedBox(height: 32),
            _buildLabel('Screenshots (Before & After)'),
            Row(
              children: [
                Expanded(child: _buildScreenshotUploader('Before')),
                const SizedBox(width: 16),
                Expanded(child: _buildScreenshotUploader('After')),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildLabel('Notes'),
            GlassCard(
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Additional thoughts...', border: InputBorder.none),
              ),
            ),
            
            const SizedBox(height: 40),
            GlowingButton(
              text: 'LOG TRADE', 
              onPressed: _saveTrade,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionTab(String label, Color color) {
    bool isSelected = _direction == label;
    return GestureDetector(
      onTap: () => setState(() => _direction = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.white10, width: 2),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isSelected ? color : AppColors.textSecondary, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2)),
    );
  }

  Widget _buildSelectorField(String value, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiary, size: 16),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint, {TextEditingController? controller}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildScreenshotUploader(String label) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        color: Colors.white.withValues(alpha: 0.02),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo_rounded, color: AppColors.textTertiary, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
        ],
      ),
    );
  }
}
