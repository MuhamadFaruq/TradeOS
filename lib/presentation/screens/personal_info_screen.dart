import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/profile_provider.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _balanceController;
  late TextEditingController _dailyTargetController;
  late TextEditingController _weeklyTargetController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _balanceController = TextEditingController(text: profile?.initialBalance.toString() ?? '10000.0');
    _dailyTargetController = TextEditingController(text: profile?.dailyProfitTarget.toString() ?? '100.0');
    _weeklyTargetController = TextEditingController(text: profile?.weeklyProfitTarget.toString() ?? '500.0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _balanceController.dispose();
    _dailyTargetController.dispose();
    _weeklyTargetController.dispose();
    super.dispose();
  }

  void _save() {
    final profile = ref.read(profileProvider);
    if (profile != null) {
      profile.name = _nameController.text;
      profile.email = _emailController.text;
      profile.initialBalance = double.tryParse(_balanceController.text) ?? profile.initialBalance;
      profile.dailyProfitTarget = double.tryParse(_dailyTargetController.text) ?? profile.dailyProfitTarget;
      profile.weeklyProfitTarget = double.tryParse(_weeklyTargetController.text) ?? profile.weeklyProfitTarget;
      
      ref.read(profileProvider.notifier).updateProfile(profile);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInput('Name', _nameController, Icons.person_outline_rounded),
            const SizedBox(height: 20),
            _buildInput('Email', _emailController, Icons.email_outlined),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('TRADING GOALS', style: TextStyle(color: AppColors.textTertiary, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 10)),
            ),
            const SizedBox(height: 16),
            _buildInput('Initial Balance (\$)', _balanceController, Icons.account_balance_wallet_outlined, isNumber: true),
            const SizedBox(height: 20),
            _buildInput('Daily Profit Target (\$)', _dailyTargetController, Icons.track_changes_rounded, isNumber: true),
            const SizedBox(height: 20),
            _buildInput('Weekly Profit Target (\$)', _weeklyTargetController, Icons.calendar_today_rounded, isNumber: true),
            const SizedBox(height: 40),
            GlowingButton(text: 'SAVE CHANGES', onPressed: _save),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(icon, color: AppColors.primary, size: 20),
              border: InputBorder.none,
              hintText: 'Enter $label',
            ),
          ),
        ),
      ],
    );
  }
}
