import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/profile_provider.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Biometrics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildToggle(
            'Biometric Authentication',
            'Use FaceID or Fingerprint to unlock.',
            profile?.biometricsEnabled ?? false,
            (v) {
              if (profile != null) {
                profile.biometricsEnabled = v;
                ref.read(profileProvider.notifier).updateProfile(profile);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildActionItem(Icons.password_rounded, 'Change App Passcode'),
          _buildActionItem(Icons.vibration_rounded, 'Haptic Feedback on Error'),
          const SizedBox(height: 32),
          _buildLabel('Account Security'),
          const SizedBox(height: 16),
          _buildActionItem(Icons.alternate_email_rounded, 'Change Email Address'),
          _buildActionItem(Icons.lock_reset_rounded, 'Reset Password'),
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

  Widget _buildActionItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 14),
          ],
        ),
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
