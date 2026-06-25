import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/trade_provider.dart';
import '../../data/providers/profile_provider.dart';
import 'personal_info_screen.dart';
import 'app_preferences_screen.dart';
import 'security_settings_screen.dart';
import 'auth_screen.dart';
import '../../core/services/export_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trades = ref.watch(tradeProvider);
    final profile = ref.watch(profileProvider);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildProfileHeader(context, profile?.name ?? 'Alex Trader', trades.length),
          const SizedBox(height: 32),
          _buildLabel('Account'),
          const SizedBox(height: 16),
          _buildActionItem(
            Icons.person_outline_rounded, 
            'Personal Information',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen())),
          ),
          _buildActionItem(
            Icons.security_rounded, 
            'Security & Biometrics',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SecuritySettingsScreen())),
          ),
          
          const SizedBox(height: 32),
          _buildLabel('Data Management'),
          const SizedBox(height: 16),
          _buildActionItem(
            Icons.download_rounded, 
            'Export Trade History (PDF/CSV)', 
            onTap: () => _handleExport(context, ref),
          ),
          _buildActionItem(
            Icons.delete_forever_rounded, 
            'Clear All Trade Data', 
            isDestructive: true,
            onTap: () => _showClearDataDialog(context, ref),
          ),

          const SizedBox(height: 32),
          _buildLabel('Trading Settings'),
          const SizedBox(height: 16),
          _buildActionItem(
            Icons.settings_outlined, 
            'App Preferences',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppPreferencesScreen())),
          ),
          _buildActionItem(
            Icons.account_balance_wallet_outlined,
            'Trading Accounts',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trading accounts configuration coming soon...')),
              );
            },
          ),
          
          const SizedBox(height: 40),
          _buildLogoutButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, int tradeCount) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person_rounded, size: 40, color: Colors.black),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$tradeCount Trades Logged', style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('PRO MEMBER', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.textTertiary), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, {VoidCallback? onTap, bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: isDestructive ? AppColors.danger : AppColors.textSecondary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title, 
                  style: TextStyle(
                    fontWeight: FontWeight.w500, 
                    color: isDestructive ? AppColors.danger : Colors.white
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.arrow_forward_ios_rounded, color: isDestructive ? AppColors.danger.withValues(alpha: 0.5) : AppColors.textTertiary, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
          );
        },
        child: const Text('Log Out', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12),
    );
  }

  void _handleExport(BuildContext context, WidgetRef ref) {
    final trades = ref.read(tradeProvider);
    if (trades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No trades to export.')),
      );
      return;
    }

    final profile = ref.read(profileProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Export Trade History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your preferred format. PDF is a beautiful analytical report, while CSV is ideal for external spreadsheet imports.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
                  title: const Text('Export PDF Report', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('With premium visual formatting & statistics', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                  onTap: () async {
                    Navigator.pop(context);
                    _showLoading(context, 'Generating PDF...');
                    try {
                      final path = await ExportService.exportToPdf(trades, profile);
                      if (!context.mounted) return;
                      Navigator.pop(context); // close loading
                      await ExportService.shareFile(path, 'TradeOS PDF Report');
                    } catch (e) {
                      if (!context.mounted) return;
                      Navigator.pop(context); // close loading
                      _showError(context, 'Failed to generate PDF: $e');
                    }
                  },
                ),
                const Divider(color: AppColors.textTertiary, height: 1),
                ListTile(
                  leading: const Icon(Icons.table_rows_rounded, color: AppColors.primary),
                  title: const Text('Export CSV Spreadsheet', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Compatible with Excel and Google Sheets', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                  onTap: () async {
                    Navigator.pop(context);
                    _showLoading(context, 'Generating CSV...');
                    try {
                      final path = await ExportService.exportToCsv(trades);
                      if (!context.mounted) return;
                      Navigator.pop(context); // close loading
                      await ExportService.shareFile(path, 'TradeOS CSV Export');
                    } catch (e) {
                      if (!context.mounted) return;
                      Navigator.pop(context); // close loading
                      _showError(context, 'Failed to generate CSV: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(width: 20),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear All Data?'),
        content: const Text('Do you want to clear all trade records? You can also optionally reset your initial balance to zero.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(tradeProvider.notifier).clearAllTrades();
              
              // Reset profile balance to 0
              final profile = ref.read(profileProvider);
              if (profile != null) {
                profile.initialBalance = 0.0;
                profile.dailyProfitTarget = 0.0;
                profile.weeklyProfitTarget = 0.0;
                await ref.read(profileProvider.notifier).updateProfile(profile);
              }
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All trade data and balance have been reset.')),
                );
              }
            },
            child: const Text('RESET EVERYTHING', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
