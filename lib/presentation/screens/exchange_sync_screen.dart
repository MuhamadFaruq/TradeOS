import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../core/services/exchange_api_service.dart';
import '../../data/providers/trade_provider.dart';
import '../../data/models/trade.dart';

class ExchangeSyncScreen extends ConsumerStatefulWidget {
  const ExchangeSyncScreen({super.key});

  @override
  ConsumerState<ExchangeSyncScreen> createState() => _ExchangeSyncScreenState();
}

class _ExchangeSyncScreenState extends ConsumerState<ExchangeSyncScreen> {
  String _selectedExchange = 'Binance';
  final _apiKeyController = TextEditingController();
  final _apiSecretController = TextEditingController();
  final _symbolController = TextEditingController(text: 'BTCUSDT');

  bool _isLoading = false;
  String? _error;
  List<Trade> _previewTrades = [];
  bool _savedCredentialsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    _symbolController.dispose();
    super.dispose();
  }

  // Load saved credentials from secure storage if available
  Future<void> _loadSavedCredentials() async {
    try {
      final creds = await ExchangeApiService.getCredentials(_selectedExchange);
      if (!mounted) return;
      if (creds['apiKey'] != null && creds['apiSecret'] != null) {
        setState(() {
          _apiKeyController.text = creds['apiKey']!;
          _apiSecretController.text = creds['apiSecret']!;
          _savedCredentialsLoaded = true;
        });
      } else {
        setState(() {
          _apiKeyController.clear();
          _apiSecretController.clear();
          _savedCredentialsLoaded = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }

  // Auto-fill demo credentials for immediate testing
  void _fillDemoCredentials() {
    setState(() {
      _apiKeyController.text = 'demo_api_key_tradeos';
      _apiSecretController.text = 'demo_api_secret_tradeos';
      _symbolController.text = 'BTCUSDT';
      _error = null;
    });
  }

  // Perform API Sync simulation or network request
  Future<void> _syncTrades() async {
    if (_apiKeyController.text.isEmpty || _apiSecretController.text.isEmpty) {
      setState(() => _error = 'Please fill in both API Key and API Secret');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _previewTrades = [];
    });

    try {
      List<Trade> fetched;
      if (_selectedExchange == 'Binance') {
        fetched = await ExchangeApiService.fetchBinanceTrades(
          apiKey: _apiKeyController.text,
          apiSecret: _apiSecretController.text,
          symbol: _symbolController.text.trim(),
        );
      } else {
        fetched = await ExchangeApiService.fetchBybitTrades(
          apiKey: _apiKeyController.text,
          apiSecret: _apiSecretController.text,
          symbol: _symbolController.text.trim(),
        );
      }

      if (!mounted) return;
      setState(() {
        _previewTrades = fetched;
        _isLoading = false;
      });

      if (fetched.isEmpty) {
        setState(() => _error = 'Sync successful, but no executions/trades were found for ${_symbolController.text}.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Save previewed trades and securely save API credentials
  Future<void> _importAndSave() async {
    if (_previewTrades.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 1. Add trades to database provider
      await ref.read(tradeProvider.notifier).addTrades(_previewTrades);

      // 2. Save credentials to secure storage for next time
      await ExchangeApiService.saveCredentials(
        exchange: _selectedExchange,
        apiKey: _apiKeyController.text,
        apiSecret: _apiSecretController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully imported ${_previewTrades.length} trades from $_selectedExchange!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error importing trades: $e';
        _isLoading = false;
      });
    }
  }

  // Clear credentials from secure storage
  Future<void> _deleteSavedCredentials() async {
    await ExchangeApiService.clearCredentials(_selectedExchange);
    if (!mounted) return;
    setState(() {
      _apiKeyController.clear();
      _apiSecretController.clear();
      _savedCredentialsLoaded = false;
      _previewTrades = [];
      _error = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved credentials deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('API Auto-Sync', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sync Exchange Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Connect your exchange API (Read-Only) to sync completed trades directly into your journal.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Exchange Selector Row
            Row(
              children: [
                Expanded(child: _buildExchangeTab('Binance')),
                const SizedBox(width: 12),
                Expanded(child: _buildExchangeTab('Bybit')),
              ],
            ),
            const SizedBox(height: 24),

            // Credentials Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_selectedExchange API CONFIG',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0, fontSize: 11),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                        icon: const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.primary),
                        label: const Text('Demo Key', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                        onPressed: _fillDemoCredentials,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputField('API Key', controller: _apiKeyController),
                  const SizedBox(height: 12),
                  _buildInputField('API Secret', controller: _apiSecretController, isPassword: true),
                  const SizedBox(height: 12),
                  _buildInputField('Symbol Pair (e.g. BTCUSDT)', controller: _symbolController),
                  const SizedBox(height: 16),
                  if (_savedCredentialsLoaded)
                    TextButton.icon(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 16),
                      label: const Text('Delete Saved Credentials', style: TextStyle(color: AppColors.danger, fontSize: 12)),
                      onPressed: _deleteSavedCredentials,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Error Display
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
              ),

            // Sync Buttons
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else ...[
              GlowingButton(
                text: 'CONNECT & SYNC TRADES',
                onPressed: _syncTrades,
              ),
            ],

            // Preview Section
            if (_previewTrades.isNotEmpty) ...[
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Preview synced trades (${_previewTrades.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Text('Ready to Import', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _previewTrades.length,
                itemBuilder: (context, index) {
                  final trade = _previewTrades[index];
                  final isWon = trade.pnl >= 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trade.pair, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(
                                '${trade.direction.name.toUpperCase()} • ${trade.confluences?.join(', ') ?? "No Confluences"}',
                                style: const TextStyle(color: AppColors.textTertiary, fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isWon ? '+' : ''}\$${trade.pnl.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: isWon ? AppColors.success : AppColors.danger),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${isWon ? '+' : ''}${trade.pnlPercentage.toStringAsFixed(2)}%',
                                style: TextStyle(color: isWon ? AppColors.success.withValues(alpha: 0.8) : AppColors.danger.withValues(alpha: 0.8), fontSize: 10),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              GlowingButton(
                text: 'CONFIRM IMPORT TO JOURNAL',
                onPressed: _importAndSave,
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeTab(String name) {
    bool isSelected = _selectedExchange == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedExchange = name;
          _previewTrades = [];
          _error = null;
        });
        _loadSavedCredentials();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.white10, width: 2),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {required TextEditingController controller, bool isPassword = false}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
