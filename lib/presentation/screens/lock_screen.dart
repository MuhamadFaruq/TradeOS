import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/core_widgets.dart';
import '../../data/providers/profile_provider.dart';
import 'home_dashboard.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> with SingleTickerProviderStateMixin {
  final LocalAuthentication _auth = LocalAuthentication();
  String _enteredPin = '';
  bool _isWrongPin = false;
  bool _isChecking = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
        setState(() {
          _isWrongPin = false;
          _enteredPin = '';
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerBiometricsIfNeeded();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _triggerBiometricsIfNeeded() async {
    final profile = ref.read(profileProvider);
    if (profile == null || !profile.biometricsEnabled) return;

    try {
      final isAvailable = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (isAvailable && isDeviceSupported) {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Autentikasi untuk membuka TradeOS',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (authenticated && mounted) {
          _triggerHaptic(HapticFeedback.lightImpact);
          _navigateToDashboard();
        }
      }
    } catch (e) {
      debugPrint('Biometrics auth error: $e');
    }
  }

  void _triggerHaptic(Future<void> Function() hapticMethod) {
    final profile = ref.read(profileProvider);
    if (profile?.hapticEnabled ?? true) {
      hapticMethod();
    }
  }

  void _onKeyPress(String digit) {
    if (_enteredPin.length >= 4 || _isChecking) return;

    _triggerHaptic(HapticFeedback.lightImpact);
    setState(() {
      _enteredPin += digit;
    });

    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _onDeletePress() {
    if (_enteredPin.isEmpty || _isChecking) return;
    _triggerHaptic(HapticFeedback.lightImpact);
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  Future<void> _verifyPin() async {
    final profile = ref.read(profileProvider);
    final correctPasscode = profile?.appPasscode ?? '';

    setState(() {
      _isChecking = true;
    });

    // Sedikit delay simulasi agar pengguna melihat titik ke-4 menyala
    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    if (_enteredPin == correctPasscode) {
      _triggerHaptic(HapticFeedback.mediumImpact);
      _navigateToDashboard();
    } else {
      _triggerHaptic(HapticFeedback.vibrate);
      setState(() {
        _isWrongPin = true;
        _isChecking = false;
      });
      _shakeController.forward();
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeDashboard(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final hasBiometrics = profile?.biometricsEnabled ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'KEAMANAN TRADEOS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan PIN untuk Membuka Jurnal',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const Spacer(flex: 1),

              // PIN Indicators
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value * (1 - _shakeController.value * 2).sign, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool isActive = index < _enteredPin.length;
                        Color dotColor = Colors.white24;
                        if (_isWrongPin) {
                          dotColor = AppColors.danger;
                        } else if (isActive) {
                          dotColor = AppColors.primary;
                        }

                        return Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor,
                            boxShadow: isActive && !_isWrongPin
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              const Spacer(flex: 1),

              // Grid Keypad
              _buildKeypad(hasBiometrics),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(bool hasBiometrics) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['1', '2', '3'].map((digit) => _buildKeypadButton(digit)).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['4', '5', '6'].map((digit) => _buildKeypadButton(digit)).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['7', '8', '9'].map((digit) => _buildKeypadButton(digit)).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Biometrik jika diaktifkan
            hasBiometrics
                ? _buildBiometricButton()
                : const SizedBox(width: 70, height: 70), // Placeholder agar layout tetap rapi
            _buildKeypadButton('0'),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return SizedBox(
      width: 70,
      height: 70,
      child: GestureDetector(
        onTap: () => _onKeyPress(digit),
        child: GlassCard(
          enableBlur: false,
          padding: EdgeInsets.zero,
          borderRadius: 35,
          borderColor: Colors.white.withValues(alpha: 0.05),
          child: Center(
            child: Text(
              digit,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return SizedBox(
      width: 70,
      height: 70,
      child: GestureDetector(
        onTap: () {
          _triggerHaptic(HapticFeedback.lightImpact);
          _triggerBiometricsIfNeeded();
        },
        child: GlassCard(
          enableBlur: false,
          padding: EdgeInsets.zero,
          borderRadius: 35,
          borderColor: AppColors.primary.withValues(alpha: 0.2),
          child: const Center(
            child: Icon(
              Icons.fingerprint_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: 70,
      height: 70,
      child: GestureDetector(
        onTap: _onDeletePress,
        child: GlassCard(
          enableBlur: false,
          padding: EdgeInsets.zero,
          borderRadius: 35,
          borderColor: Colors.white.withValues(alpha: 0.05),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
