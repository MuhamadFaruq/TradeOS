import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';

class RiskManagementScreen extends StatefulWidget {
  const RiskManagementScreen({super.key});

  @override
  State<RiskManagementScreen> createState() => _RiskManagementScreenState();
}

class _RiskManagementScreenState extends State<RiskManagementScreen> {
  final TextEditingController _balanceController = TextEditingController(text: '10000');
  final TextEditingController _riskController = TextEditingController(text: '1');
  final TextEditingController _slController = TextEditingController(text: '20');
  
  // Futures Calculator State
  final TextEditingController _entryPriceController = TextEditingController(text: '65000');
  final TextEditingController _futuresLeverageController = TextEditingController(text: '20');
  double _liqPrice = 0.0;

  double _positionSize = 0.50;
  double _totalRisk = 100.0;

  @override
  void initState() {
    super.initState();
    _calculate();
    _calculateLiquidation();
  }

  void _calculate() {
    final balance = double.tryParse(_balanceController.text) ?? 0;
    final riskPercent = double.tryParse(_riskController.text) ?? 0;
    final slPips = double.tryParse(_slController.text) ?? 1;

    setState(() {
      _totalRisk = balance * (riskPercent / 100);
      _positionSize = _totalRisk / (slPips * 10);
    });
  }

  void _calculateLiquidation() {
    final entry = double.tryParse(_entryPriceController.text) ?? 0;
    final leverage = double.tryParse(_futuresLeverageController.text) ?? 1;
    
    if (leverage == 0) return;
    
    setState(() {
      // Very simple liquidation formula for isolated margin: Entry * (1 - 1/Leverage) for Longs
      _liqPrice = entry * (1 - (1 / leverage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Risk Management', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalculatorCard(),
            const SizedBox(height: 24),
            _buildFuturesCalculatorCard(),
            const SizedBox(height: 32),
            _buildLabel('Current Exposure'),
            const SizedBox(height: 16),
            _buildExposureStats(),
            const SizedBox(height: 32),
            _buildLabel('Prop Firm Mode'),
            const SizedBox(height: 16),
            _buildPropFirmCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calculate_rounded, color: AppColors.primary),
              SizedBox(width: 12),
              Text('Position Size Calculator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 24),
          _buildCalcInput('Account Balance (\$)', _balanceController),
          const SizedBox(height: 16),
          _buildCalcInput('Risk Percentage (%)', _riskController),
          const SizedBox(height: 16),
          _buildCalcInput('Stop Loss (Pips)', _slController),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('Recommended Position Size', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  '${_positionSize.toStringAsFixed(2)} Lots',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Risking \$${_totalRisk.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturesCalculatorCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up_rounded, color: AppColors.accent),
              SizedBox(width: 12),
              Text('Futures Liq. Calculator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 24),
          _buildCalcInput('Entry Price (\$)', _entryPriceController, onChanged: (_) => _calculateLiquidation()),
          const SizedBox(height: 16),
          _buildCalcInput('Leverage (x)', _futuresLeverageController, onChanged: (_) => _calculateLiquidation()),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('Est. Liquidation Price (Long)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  '\$${_liqPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcInput(String label, TextEditingController controller, {Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged ?? (_) => _calculate(),
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildExposureStats() {
    return const Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Open Risk', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                SizedBox(height: 8),
                Text('\$0.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.success)),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Daily Drawdown', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                SizedBox(height: 8),
                Text('0.0%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropFirmCard() {
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Prop Firm Rules', style: TextStyle(fontWeight: FontWeight.bold)),
              Switch(value: true, onChanged: (v) {}, activeThumbColor: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          _buildRuleRow('Daily Loss Limit', '\$500.00', 0.0),
          const SizedBox(height: 12),
          _buildRuleRow('Overall Drawdown', '\$1,200.00', 0.0),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String label, String value, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation<Color>(progress > 0.7 ? AppColors.danger : AppColors.primary),
          borderRadius: BorderRadius.circular(4),
        ),
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
