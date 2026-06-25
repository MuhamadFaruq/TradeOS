import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/models/trade.dart';
import '../../data/providers/trade_provider.dart';
import '../../data/providers/portfolio_provider.dart';

class AddTradeScreen extends ConsumerStatefulWidget {
  const AddTradeScreen({super.key});

  @override
  ConsumerState<AddTradeScreen> createState() => _AddTradeScreenState();
}

class _AddTradeScreenState extends ConsumerState<AddTradeScreen> {
  String _direction = 'LONG';
  String _session = 'LONDON';
  String _emotion = 'CALM';
  double _confidence = 5.0;
  String _brokenRule = 'None / Stuck to Plan';
  AssetClass _assetClass = AssetClass.cryptoSpot;
  
  final List<String> _mistakeOptions = [
    'None / Stuck to Plan',
    'FOMO (Fear of Missing Out)',
    'Revenge Trading',
    'Early Exit',
    'Overleveraged',
    'Ignoring SL/TP',
    'Overtrading',
  ];
  
  final _pairController = TextEditingController(text: 'BTC/USDT');
  final _confluencesController = TextEditingController(text: 'Bull Flag, Trendline');
  final _expectedEntryController = TextEditingController();
  final List<Map<String, TextEditingController>> _partialExitControllers = [];
  final _entryPriceController = TextEditingController();
  final _exitPriceController = TextEditingController();
  final _amountController = TextEditingController();
  final _leverageController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _cvdController = TextEditingController();
  final _volumeImbalanceController = TextEditingController();
  final _totalVolumeController = TextEditingController();
  final _durationMinutesController = TextEditingController();
  final _stopLossController = TextEditingController();
  final _takeProfitController = TextEditingController();
  final _commissionController = TextEditingController();
  final _swapController = TextEditingController();
  final _maeController = TextEditingController();
  final _mfeController = TextEditingController();

  // Asset class specific controllers
  final _lotSizeController = TextEditingController();
  final _pipsController = TextEditingController();
  final _liquidationPriceController = TextEditingController();
  final _fundingFeeController = TextEditingController();
 
  // Screenshot tracking
  final List<String> _beforeEntryScreenshots = [];
  final List<String> _afterExitScreenshots = [];
 
  @override
  void dispose() {
    _pairController.dispose();
    _confluencesController.dispose();
    _expectedEntryController.dispose();
    for (var c in _partialExitControllers) {
      c['price']?.dispose();
      c['amount']?.dispose();
    }
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _amountController.dispose();
    _leverageController.dispose();
    _notesController.dispose();
    _cvdController.dispose();
    _volumeImbalanceController.dispose();
    _totalVolumeController.dispose();
    _durationMinutesController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _commissionController.dispose();
    _swapController.dispose();
    _maeController.dispose();
    _mfeController.dispose();
    _lotSizeController.dispose();
    _pipsController.dispose();
    _liquidationPriceController.dispose();
    _fundingFeeController.dispose();
    super.dispose();
  }

  String? _validationError;

  void _saveTrade() {
    // Reset error
    setState(() => _validationError = null);

    // Mandatory Fields validation
    if (_pairController.text.isEmpty) {
      setState(() => _validationError = 'Please enter trading pair');
      return;
    }

    final entryPrice = double.tryParse(_entryPriceController.text);
    if (entryPrice == null || entryPrice <= 0) {
      setState(() => _validationError = 'Please enter valid entry price');
      return;
    }

    // Optional fields with defaults
    final exitPrice = double.tryParse(_exitPriceController.text);
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final leverage = double.tryParse(_leverageController.text) ?? 1.0;
    
    // Status and PnL calculation
    TradeStatus status = TradeStatus.open;
    double pnl = 0.0;
    double pnlPercentage = 0.0;
    double commission = double.tryParse(_commissionController.text) ?? 0.0;
    double swapOrFees = double.tryParse(_swapController.text) ?? 0.0;

    if (exitPrice != null && exitPrice > 0) {
      final isLong = _direction == 'LONG';
      final multiplier = isLong ? 1 : -1;
      
      double grossPnl = 0.0;
      double tradeCost = amount; // default cost is amount (for ROI percent calculation)

      if (_assetClass == AssetClass.forex) {
        final lotSize = double.tryParse(_lotSizeController.text) ?? 0.1;
        // Standard forex: 1 Lot = 100,000 base currency units
        grossPnl = (exitPrice - entryPrice) * lotSize * 100000 * multiplier;
        tradeCost = lotSize * 1000; // estimated margin cost
      } else if (_assetClass == AssetClass.cryptoFutures) {
        final margin = double.tryParse(_amountController.text) ?? 0.0;
        final leverageVal = double.tryParse(_leverageController.text) ?? 1.0;
        final funding = double.tryParse(_fundingFeeController.text) ?? 0.0;
        
        grossPnl = ((exitPrice - entryPrice) / entryPrice) * margin * leverageVal * multiplier;
        grossPnl -= funding;
        tradeCost = margin;
      } else {
        // Crypto Spot
        final totalInvestment = double.tryParse(_amountController.text) ?? 0.0;
        grossPnl = ((exitPrice - entryPrice) / entryPrice) * totalInvestment * multiplier;
        tradeCost = totalInvestment;
      }

      pnl = grossPnl - commission + (_assetClass == AssetClass.forex ? swapOrFees : -swapOrFees);
      pnlPercentage = tradeCost > 0 ? (pnl / tradeCost) * 100 : 0.0;
      status = pnl >= 0 ? TradeStatus.won : TradeStatus.lost;
    }

    final wasRuleBroken = _brokenRule != 'None / Stuck to Plan';
    final brokenRule = wasRuleBroken ? _brokenRule : null;

    final trade = Trade.create(
      pair: _pairController.text,
      direction: _direction == 'LONG' ? TradeDirection.long : TradeDirection.short,
      entryPrice: entryPrice,
      exitPrice: exitPrice,
      amount: _assetClass == AssetClass.forex 
          ? (double.tryParse(_lotSizeController.text) ?? 0.0) 
          : amount,
      pnl: pnl,
      pnlPercentage: pnlPercentage,
      status: status,
      date: DateTime.now(),
      assetClass: _assetClass,
      lotSize: _assetClass == AssetClass.forex ? double.tryParse(_lotSizeController.text) : null,
      pips: _assetClass == AssetClass.forex ? double.tryParse(_pipsController.text) : null,
      liquidationPrice: _assetClass == AssetClass.cryptoFutures ? double.tryParse(_liquidationPriceController.text) : null,
      fundingFee: _assetClass == AssetClass.cryptoFutures ? double.tryParse(_fundingFeeController.text) : null,
      confluences: _confluencesController.text.isNotEmpty ? _confluencesController.text.split(',').map((e) => e.trim()).toList() : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      emotion: _emotion,
      session: _session,
      confidence: _confidence.toInt(),
      wasRuleBroken: wasRuleBroken,
      brokenRule: brokenRule,
      commission: commission,
      swap: _assetClass == AssetClass.forex ? swapOrFees : 0.0,
    );

    trade.leverage = leverage;

    // Professional metrics
    trade.expectedEntryPrice = double.tryParse(_expectedEntryController.text);
    if (trade.expectedEntryPrice != null && entryPrice != null && trade.expectedEntryPrice! > 0) {
       trade.slippage = (entryPrice - trade.expectedEntryPrice!).abs() / trade.expectedEntryPrice! * 100;
    }
    
    if (_partialExitControllers.isNotEmpty) {
      trade.partialExits = _partialExitControllers.map((c) {
        return PartialExit(
          exitPrice: double.tryParse(c['price']?.text ?? ''),
          amount: double.tryParse(c['amount']?.text ?? ''),
          date: DateTime.now(),
        );
      }).where((pe) => pe.exitPrice != null && pe.exitPrice! > 0).toList();
      
      if (trade.partialExits!.isNotEmpty) {
        // Calculate average exit price for Actual RRR
        double totalExitValue = 0;
        double totalExitAmount = 0;
        for (var pe in trade.partialExits!) {
          totalExitValue += (pe.exitPrice! * (pe.amount ?? 1));
          totalExitAmount += (pe.amount ?? 1);
        }
        double avgExitPrice = totalExitValue / totalExitAmount;
        
        if (trade.stopLossPrice != null && trade.stopLossPrice != 0) {
          trade.actualRRR = (avgExitPrice - trade.entryPrice).abs() / 
                                (trade.stopLossPrice! - trade.entryPrice).abs();
        }
      }
    }

    // Add advanced metrics
    trade.cvd = double.tryParse(_cvdController.text);
    trade.volumeImbalance = double.tryParse(_volumeImbalanceController.text);
    trade.totalVolume = double.tryParse(_totalVolumeController.text);
    trade.durationMinutes = int.tryParse(_durationMinutesController.text);
    trade.stopLossPrice = double.tryParse(_stopLossController.text);
    trade.takeProfitPrice = double.tryParse(_takeProfitController.text);
    trade.mae = double.tryParse(_maeController.text);
    trade.mfe = double.tryParse(_mfeController.text);

    // Add screenshots
    if (_beforeEntryScreenshots.isNotEmpty) {
      trade.beforeEntryScreenshots = List.from(_beforeEntryScreenshots);
    }
    if (_afterExitScreenshots.isNotEmpty) {
      trade.afterExitScreenshots = List.from(_afterExitScreenshots);
    }

    // Calculate RR if SL and TP exist
    if (trade.stopLossPrice != null && trade.takeProfitPrice != null && trade.stopLossPrice != 0) {
      trade.plannedRRR = (trade.takeProfitPrice! - trade.entryPrice).abs() / 
                            (trade.stopLossPrice! - trade.entryPrice).abs();
      // If no partial exits, actual RRR is based on exitPrice
      if ((trade.partialExits == null || trade.partialExits!.isEmpty) && exitPrice != null && exitPrice > 0) {
         trade.actualRRR = (exitPrice - trade.entryPrice).abs() / (trade.stopLossPrice! - trade.entryPrice).abs();
      }
    }

    ref.read(tradeProvider.notifier).addTrade(trade);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                pnl >= 0 ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Trade Logged Successfully',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Net PnL: ${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: pnl >= 0 ? AppColors.success : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
        elevation: 0,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.pop(context);
    });
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
            // Error Message
            if (_validationError != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                ),
                child: Text(_validationError!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
              ),

            // Direction Toggle
            Row(
              children: [
                Expanded(child: _buildDirectionTab('LONG', AppColors.success)),
                const SizedBox(width: 16),
                Expanded(child: _buildDirectionTab('SHORT', AppColors.danger)),
              ],
            ),
            const SizedBox(height: 32),
            
            _buildAssetClassToggle(),
            
            _buildLabel('Trading Pair & Setup'),
            Row(
              children: [
                Expanded(child: _buildInputField(_assetClass == AssetClass.forex ? 'Pair (e.g. EUR/USD)' : 'Pair (e.g. BTC/USDT)', controller: _pairController)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Confluences (comma separated)', controller: _confluencesController)),
              ],
            ),
            
            const SizedBox(height: 24),
            _buildLabel('Entry Details'),
            Row(
              children: [
                Expanded(child: _buildInputField('Expected Entry', controller: _expectedEntryController, inputType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Actual Entry', controller: _entryPriceController, inputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel('Exit Details'),
            Row(
              children: [
                Expanded(child: _buildInputField('Final Exit Price', controller: _exitPriceController, inputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 8),
            _buildPartialExitsList(),
            const SizedBox(height: 16),
            
            if (_assetClass == AssetClass.forex) ...[
              Row(
                children: [
                  Expanded(child: _buildInputField('Lot Size', controller: _lotSizeController, inputType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInputField('Pips (Optional)', controller: _pipsController, inputType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
            ] else if (_assetClass == AssetClass.cryptoFutures) ...[
              Row(
                children: [
                  Expanded(child: _buildInputField('Margin Amount (\$)', controller: _amountController, inputType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInputField('Leverage (x)', controller: _leverageController, inputType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInputField('Liquidation Price', controller: _liquidationPriceController, inputType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInputField('Funding Fee (\$)', controller: _fundingFeeController, inputType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
            ] else ...[
              Row(
                children: [
                  Expanded(child: _buildInputField('Total Investment (\$)', controller: _amountController, inputType: TextInputType.number)),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            _buildLabel('Risk Management'),
            Row(
               children: [
                 Expanded(child: _buildInputField(_assetClass == AssetClass.forex ? 'Stop Loss (Pips/Price)' : 'Stop Loss Price', controller: _stopLossController, inputType: TextInputType.number)),
                 const SizedBox(width: 12),
                 Expanded(child: _buildInputField(_assetClass == AssetClass.forex ? 'Take Profit (Pips/Price)' : 'Take Profit Price', controller: _takeProfitController, inputType: TextInputType.number)),
               ],
             ),
             const SizedBox(height: 16),
             Row(
               children: [
                 Expanded(child: _buildInputField('Commission (\$)', controller: _commissionController, inputType: TextInputType.number)),
                 const SizedBox(width: 12),
                 Expanded(child: _buildInputField(_assetClass == AssetClass.forex ? 'Swap (\$)' : 'Fees (\$)', controller: _swapController, inputType: TextInputType.number)),
               ],
             ),

            const SizedBox(height: 24),
            _buildLabel('Order Flow & Excursion Metrics (Optional)'),
            Row(
              children: [
                Expanded(child: _buildInputField('CVD (-1.0 to 1.0)', controller: _cvdController, inputType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('Vol Imbalance', controller: _volumeImbalanceController, inputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('MAE Price (Max Adverse)', controller: _maeController, inputType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('MFE Price (Max Favorable)', controller: _mfeController, inputType: TextInputType.number)),
              ],
            ),
            
            const SizedBox(height: 32),
            _buildLabel('Session & Psychology'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showSessionSheet,
                    child: _buildSelectorField(_session, Icons.schedule_rounded),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _showEmotionSheet,
                    child: _buildSelectorField(_emotion, Icons.sentiment_satisfied_rounded),
                  ),
                ),
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
            GestureDetector(
              onTap: _showMistakesSheet,
              child: _buildSelectorField(_brokenRule, Icons.report_problem_rounded),
            ),
            
            const SizedBox(height: 32),
            _buildLabel('Screenshots (Before & After)'),
            Row(
              children: [
                Expanded(child: _buildScreenshotUploader('Before', _beforeEntryScreenshots.length)),
                const SizedBox(width: 16),
                Expanded(child: _buildScreenshotUploader('After', _afterExitScreenshots.length)),
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

  void _showSessionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Trading Session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['LONDON', 'NEW YORK', 'ASIA/TOKYO'].map((option) {
              final isSelected = _session == option;
              return ListTile(
                leading: const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 20),
                title: Text(
                  option,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _session = option);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEmotionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Psychology/Emotion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['CALM', 'FOMO', 'GREED', 'FEAR', 'HOPE', 'DISCIPLINED'].map((option) {
              final isSelected = _emotion == option;
              return ListTile(
                leading: const Icon(Icons.sentiment_satisfied_rounded, color: AppColors.primary, size: 20),
                title: Text(
                  option,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _emotion = option);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showMistakesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Mistake / Rule Broken', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._mistakeOptions.map((option) {
              final isSelected = _brokenRule == option;
              return ListTile(
                leading: Icon(
                  option == 'None / Stuck to Plan' ? Icons.check_circle_rounded : Icons.report_problem_rounded,
                  color: isSelected
                      ? AppColors.primary
                      : (option == 'None / Stuck to Plan' ? AppColors.success : AppColors.danger),
                  size: 20,
                ),
                title: Text(
                  option,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _brokenRule = option);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
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

  Widget _buildInputField(String hint, {TextEditingController? controller, TextInputType inputType = TextInputType.text}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildScreenshotUploader(String label, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'Before') {
            _beforeEntryScreenshots.add('mock_path_before_${_beforeEntryScreenshots.length + 1}.png');
          } else {
            _afterExitScreenshots.add('mock_path_after_${_afterExitScreenshots.length + 1}.png');
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mock screenshot added to $label'), duration: const Duration(seconds: 1)),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: count > 0 ? AppColors.primary : Colors.white10),
          color: count > 0
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.02),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_rounded,
                color: count > 0 ? AppColors.primary : AppColors.textTertiary, size: 20),
            const SizedBox(height: 4),
            Text(
              count > 0 ? '$label ($count)' : label,
              style: TextStyle(
                color: count > 0 ? AppColors.primary : AppColors.textTertiary,
                fontSize: 10,
                fontWeight: count > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartialExitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('Partial Exits (Scaling Out)'),
            TextButton(
              onPressed: () {
                setState(() {
                  _partialExitControllers.add({
                    'price': TextEditingController(),
                    'amount': TextEditingController(),
                  });
                });
              },
              child: const Text('+ Add Partial Exit', style: TextStyle(color: AppColors.primary, fontSize: 12)),
            )
          ],
        ),
        ..._partialExitControllers.asMap().entries.map((e) {
          int index = e.key;
          var controllers = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(child: _buildInputField('TP ${index+1} Price', controller: controllers['price'], inputType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: _buildInputField('Amount/Lot Closed', controller: controllers['amount'], inputType: TextInputType.number)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.danger, size: 20),
                  onPressed: () {
                    setState(() {
                      _partialExitControllers[index]['price']?.dispose();
                      _partialExitControllers[index]['amount']?.dispose();
                      _partialExitControllers.removeAt(index);
                    });
                  },
                )
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAssetClassToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Asset Class'),
        Row(
          children: [
            Expanded(child: _buildAssetClassTab(AssetClass.cryptoSpot, 'SPOT', Icons.account_balance_wallet_rounded)),
            const SizedBox(width: 8),
            Expanded(child: _buildAssetClassTab(AssetClass.cryptoFutures, 'FUTURES', Icons.analytics_rounded)),
            const SizedBox(width: 8),
            Expanded(child: _buildAssetClassTab(AssetClass.forex, 'FOREX', Icons.currency_exchange_rounded)),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAssetClassTab(AssetClass value, String label, IconData icon) {
    bool isSelected = _assetClass == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _assetClass = value;
          // Set default pair depending on selected asset class
          if (value == AssetClass.forex && _pairController.text == 'BTC/USDT') {
            _pairController.text = 'EUR/USD';
          } else if ((value == AssetClass.cryptoSpot || value == AssetClass.cryptoFutures) && _pairController.text == 'EUR/USD') {
            _pairController.text = 'BTC/USDT';
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.white10, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textTertiary, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
