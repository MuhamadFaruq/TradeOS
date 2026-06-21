import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/profile_provider.dart';

class TradingAccountsScreen extends ConsumerStatefulWidget {
  const TradingAccountsScreen({super.key});

  @override
  ConsumerState<TradingAccountsScreen> createState() => _TradingAccountsScreenState();
}

class _TradingAccountsScreenState extends ConsumerState<TradingAccountsScreen> {
  final _accountController = TextEditingController();

  void _addAccount() {
    if (_accountController.text.isEmpty) return;
    
    final profile = ref.read(profileProvider);
    if (profile != null) {
      final updatedAccounts = List<String>.from(profile.tradingAccounts);
      updatedAccounts.add(_accountController.text);
      profile.tradingAccounts = updatedAccounts;
      
      ref.read(profileProvider.notifier).updateProfile(profile);
      _accountController.clear();
      Navigator.pop(context); // Close bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account added successfully.')),
      );
    }
  }

  void _deleteAccount(int index) {
    final profile = ref.read(profileProvider);
    if (profile != null) {
      final updatedAccounts = List<String>.from(profile.tradingAccounts);
      updatedAccounts.removeAt(index);
      profile.tradingAccounts = updatedAccounts;
      
      ref.read(profileProvider.notifier).updateProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account removed.')),
      );
    }
  }

  void _showAddAccountSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add New Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _accountController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Account Name (e.g. IC Markets Live)',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GlowingButton(text: 'ADD ACCOUNT', onPressed: _addAccount),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final accounts = profile?.tradingAccounts ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Manage your different trading accounts to track separate portfolios.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          if (accounts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('No accounts added yet.', style: TextStyle(color: AppColors.textTertiary)),
              ),
            )
          else
            ...List.generate(accounts.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 24),
                      const SizedBox(width: 16),
                      Text(accounts[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                        onPressed: () => _deleteAccount(index),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _showAddAccountSheet,
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            label: const Text('ADD NEW ACCOUNT', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
