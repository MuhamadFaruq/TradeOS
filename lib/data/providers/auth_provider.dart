import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoggedIn;
  final String? email;
  final String? userName;
  final String? tradingType;
  final String? experienceLevel;
  final String? tradingStyle;
  final bool? isPropFirmTrader;

  AuthState({
    this.isLoggedIn = false,
    this.email,
    this.userName,
    this.tradingType,
    this.experienceLevel,
    this.tradingStyle,
    this.isPropFirmTrader,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? email,
    String? userName,
    String? tradingType,
    String? experienceLevel,
    String? tradingStyle,
    bool? isPropFirmTrader,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      tradingType: tradingType ?? this.tradingType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      tradingStyle: tradingStyle ?? this.tradingStyle,
      isPropFirmTrader: isPropFirmTrader ?? this.isPropFirmTrader,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final email = prefs.getString('email');
      final userName = prefs.getString('userName');
      final tradingType = prefs.getString('tradingType');
      final experienceLevel = prefs.getString('experienceLevel');
      final tradingStyle = prefs.getString('tradingStyle');
      final isPropFirmTrader = prefs.getBool('isPropFirmTrader') ?? false;

      if (isLoggedIn) {
        state = AuthState(
          isLoggedIn: true,
          email: email,
          userName: userName,
          tradingType: tradingType,
          experienceLevel: experienceLevel,
          tradingStyle: tradingStyle,
          isPropFirmTrader: isPropFirmTrader,
        );
      }
    } catch (e) {
      print('Error loading auth state: $e');
    }
  }

  Future<void> saveOnboardingData({
    required String tradingType,
    required String experienceLevel,
    required String tradingStyle,
    required bool isPropFirmTrader,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tradingType', tradingType);
      await prefs.setString('experienceLevel', experienceLevel);
      await prefs.setString('tradingStyle', tradingStyle);
      await prefs.setBool('isPropFirmTrader', isPropFirmTrader);

      state = state.copyWith(
        tradingType: tradingType,
        experienceLevel: experienceLevel,
        tradingStyle: tradingStyle,
        isPropFirmTrader: isPropFirmTrader,
      );
    } catch (e) {
      print('Error saving onboarding data: $e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      // Simple demo login - in production, validate against backend
      if (email.isNotEmpty && password.isNotEmpty) {
        final userName = email.split('@')[0].toUpperCase();
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', email);
        await prefs.setString('userName', userName);

        state = state.copyWith(
          isLoggedIn: true,
          email: email,
          userName: userName,
        );
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('email');
      await prefs.remove('userName');

      state = AuthState();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
