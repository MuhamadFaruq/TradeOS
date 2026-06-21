import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';
import '../../core/services/gemini_service.dart';

class AIInsightsScreen extends ConsumerStatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  ConsumerState<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends ConsumerState<AIInsightsScreen> {
  String? _apiKey;
  bool _isLoading = false;
  String? _geminiReport;
  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final key = await GeminiService.getApiKey();
    final report = await GeminiService.getLatestReport();
    setState(() {
      _apiKey = key;
      _geminiReport = report;
      if (key != null) {
        _apiKeyController.text = key;
      }
    });
  }

  Future<void> _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) return;

    await GeminiService.saveApiKey(key);
    setState(() {
      _apiKey = key;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API Key Gemini berhasil disimpan!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _removeApiKey() async {
    await GeminiService.removeApiKey();
    _apiKeyController.clear();
    setState(() {
      _apiKey = null;
      _geminiReport = null;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API Key Gemini dihapus.'),
        ),
      );
    }
  }

  Future<void> _generateReport() async {
    final trades = ref.read(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);

    if (trades.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final reportText = await GeminiService.generateWeeklyReport(
        trades: trades,
        winRate: notifier.winRate,
        totalPnL: notifier.totalPnL,
        pf: notifier.profitFactor,
        disciplineRate: notifier.disciplineRate,
        mistakeCosts: notifier.mistakeCosts,
      );

      setState(() {
        _geminiReport = reportText;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat laporan: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _generateDemoReport() async {
    final trades = ref.read(tradeProvider);
    final notifier = ref.read(tradeProvider.notifier);

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final demoReport = await GeminiService.generateMockReport(
      trades: trades,
      winRate: notifier.winRate,
      totalPnL: notifier.totalPnL,
      pf: notifier.profitFactor,
      disciplineRate: notifier.disciplineRate,
      mistakeCosts: notifier.mistakeCosts,
    );

    await GeminiService.saveLatestReport(demoReport);

    setState(() {
      _geminiReport = demoReport;
      _isLoading = false;
    });
  }

  void _showApiKeyConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Config Gemini API Key', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan API Key Gemini Anda:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: 'AIzaSy...',
                hintStyle: const TextStyle(color: Colors.white24),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Open url in browser if they need (mocking instructions)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buka: https://aistudio.google.com untuk key gratis.')),
                );
              },
              child: const Text(
                'Dapatkan API Key gratis di Google AI Studio ↗',
                style: TextStyle(color: AppColors.primary, fontSize: 10, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        actions: [
          if (_apiKey != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _removeApiKey();
              },
              child: const Text('HAPUS KEY', style: TextStyle(color: AppColors.danger)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveApiKey();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradeProvider);
    final hasTrades = trades.isNotEmpty;
    final isKeyConfigured = _apiKey != null && _apiKey!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Trading Coach', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (isKeyConfigured)
            IconButton(
              icon: const Icon(Icons.vpn_key_rounded, color: AppColors.primary),
              tooltip: 'Configure Gemini API',
              onPressed: _showApiKeyConfigDialog,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasTrades) ...[
              _buildNoTradesPlaceholder()
            ] else if (!isKeyConfigured) ...[
              _buildSetupKeyCard()
            ] else if (_isLoading) ...[
              _buildLoadingCard()
            ] else if (_geminiReport != null) ...[
              _buildReportCard()
            ] else ...[
              _buildDefaultCoachPrompt(trades.length)
            ],
            const SizedBox(height: 32),
            _buildLabel('Recommended Playbook'),
            const SizedBox(height: 16),
            const GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.psychology_rounded, color: AppColors.primary),
                    title: Text('Pre-trade Meditation'),
                    subtitle: Text('Reduce FOMO before market open.'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                  Divider(color: Colors.white10),
                  ListTile(
                    leading: Icon(Icons.rule_rounded, color: AppColors.primary),
                    title: Text('Risk Scaling Rule'),
                    subtitle: Text('Cut size by 50% after 2 consecutive losses.'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTradesPlaceholder() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 48, color: Colors.white10),
            SizedBox(height: 16),
            Text(
              'Jurnalkan beberapa transaksi terlebih dahulu untuk memicu analisis AI Coach.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupKeyCard() {
    return GlassCard(
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.vpn_key_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aktifkan AI Trading Coach',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
            'Konfigurasikan API Key Gemini gratis Anda untuk menerima analisis perilaku, emosi, dan kedisiplinan trading Anda secara dinamis.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showApiKeyConfigDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(200, 50),
            ),
            child: const Text('SETUP GEMINI API KEY'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _generateDemoReport,
            child: const Text(
              'COBA DEMO AI COACH (TANPA API KEY)',
              style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return GlassCard(
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          ),
          const SizedBox(height: 24),
          const Text(
            'AI Coach Sedang Menganalisis...',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            'Memproses riwayat transaksi, menghitung dampak emosi, dan memformulasikan rencana disiplin terbaik untuk Anda...',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Laporan Analisis AI Coach'),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: MarkdownRenderer(text: _geminiReport!),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _generateReport,
              icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
              label: const Text('REGENERATE REPORT', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: _showApiKeyConfigDialog,
              child: const Text('MANAGE API KEY', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultCoachPrompt(int tradeCount) {
    return GlassCard(
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Menganalisis $tradeCount Transaksi Terakhir...',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
            '"Evaluasi dan perbaiki kedisiplinan trading Anda melalui tinjauan performa berbasis AI Coach."',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic, fontSize: 12),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _generateReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(200, 50),
            ),
            child: const Text('Generate AI Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 11),
    );
  }
}
