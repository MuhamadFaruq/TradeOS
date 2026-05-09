import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/profile_provider.dart';

class AppPreferencesScreen extends ConsumerWidget {
  const AppPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildToggle(
            'Push Notifications',
            'Receive alerts for trade setups and news.',
            profile?.notificationsEnabled ?? true,
            (v) {
              if (profile != null) {
                profile.notificationsEnabled = v;
                ref.read(profileProvider.notifier).updateProfile(profile);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildToggle(
            'Biometric Login',
            'Use FaceID or Fingerprint to secure access.',
            profile?.biometricsEnabled ?? false,
            (v) {
              if (profile != null) {
                profile.biometricsEnabled = v;
                ref.read(profileProvider.notifier).updateProfile(profile);
              }
            },
          ),
          const SizedBox(height: 32),
          _buildLabel('Trading Defaults'),
          const SizedBox(height: 16),
          _buildDropdown(
            'Default Currency',
            profile?.defaultCurrency ?? 'USD',
            ['USD', 'EUR', 'GBP', 'JPY'],
            (v) {
              if (profile != null && v != null) {
                profile.defaultCurrency = v;
                ref.read(profileProvider.notifier).updateProfile(profile);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return GlassCard(
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDropdown(String title, String value, List<String> items, Function(String?) onChanged) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: value,
            underline: Container(),
            dropdownColor: AppColors.surface,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12),
    );
  }
}
