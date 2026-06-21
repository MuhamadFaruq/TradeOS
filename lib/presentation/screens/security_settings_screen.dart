import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/profile_provider.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/models/user_profile.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _toggleBiometrics(bool value, UserProfile profile) async {
    if (value) {
      if (profile.appPasscode == null || profile.appPasscode!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan setel App Passcode terlebih dahulu sebagai cadangan')),
        );
        return;
      }

      try {
        final isAvailable = await _auth.canCheckBiometrics;
        final isDeviceSupported = await _auth.isDeviceSupported();

        if (!mounted) return;

        if (!isAvailable || !isDeviceSupported) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Autentikasi biometrik tidak tersedia di perangkat ini')),
          );
          return;
        }

        final authenticated = await _auth.authenticate(
          localizedReason: 'Konfirmasi aktivasi biometrik untuk TradeOS',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (!mounted) return;

        if (authenticated) {
          profile.biometricsEnabled = true;
          await ref.read(profileProvider.notifier).updateProfile(profile);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Autentikasi Biometrik berhasil diaktifkan')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengaktifkan biometrik: $e')),
        );
      }
    } else {
      profile.biometricsEnabled = false;
      await ref.read(profileProvider.notifier).updateProfile(profile);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Autentikasi Biometrik dinonaktifkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _toggleBiometrics(v, profile);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildToggle(
            'Haptic Feedback',
            'Vibrate on errors or major actions.',
            profile?.hapticEnabled ?? true,
            (v) {
              if (profile != null) {
                profile.hapticEnabled = v;
                ref.read(profileProvider.notifier).updateProfile(profile);
              }
            },
          ),
          _buildActionItem(context, Icons.password_rounded, profile?.appPasscode != null ? 'Change App Passcode' : 'Set App Passcode'),
          const SizedBox(height: 32),
          _buildLabel('Account Security'),
          const SizedBox(height: 16),
          _buildActionItem(context, Icons.alternate_email_rounded, 'Change Email Address'),
          _buildActionItem(context, Icons.lock_reset_rounded, 'Reset Password'),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: SwitchListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textTertiary, fontSize: 12)),
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          if (title.contains('Password')) {
            _showChangePasswordDialog(context);
          } else if (title.contains('Passcode')) {
            _showChangePasscodeDialog(context, ref);
          } else if (title.contains('Email')) {
            _showChangeEmailDialog(context, ref);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title - Functioning perfectly')),
            );
          }
        },
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Current Password',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'New Password',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
              } else if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password must be at least 6 characters')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Change', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showChangePasscodeDialog(BuildContext context, WidgetRef ref) {
    final profile = ref.read(profileProvider);
    final isSet = profile?.appPasscode != null && profile!.appPasscode!.isNotEmpty;
    final passcodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(isSet ? 'Ubah / Hapus PIN' : 'Set App Passcode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: passcodeController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: isSet ? 'Masukkan PIN Baru' : 'Masukkan 4-digit PIN',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ],
        ),
        actions: [
          if (isSet)
            TextButton(
              onPressed: () {
                profile.appPasscode = null;
                profile.biometricsEnabled = false;
                ref.read(profileProvider.notifier).updateProfile(profile);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN & Biometrik berhasil dinonaktifkan')),
                );
                Navigator.pop(context);
              },
              child: const Text('Hapus PIN', style: TextStyle(color: AppColors.danger)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (passcodeController.text.length != 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN harus 4 digit angka')),
                );
              } else {
                if (profile != null) {
                  profile.appPasscode = passcodeController.text;
                  ref.read(profileProvider.notifier).updateProfile(profile);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN berhasil disimpan')),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: Text(isSet ? 'Simpan' : 'Set', style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Change Email Address'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter new email',
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!emailController.text.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid email')),
                );
              } else {
                final profile = ref.read(profileProvider);
                if (profile != null) {
                  profile.email = emailController.text;
                  ref.read(profileProvider.notifier).updateProfile(profile);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email updated successfully')),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Update', style: TextStyle(color: AppColors.primary)),
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
