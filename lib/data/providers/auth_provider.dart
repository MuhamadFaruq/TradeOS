import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  AuthNotifier() : super(AuthState());

  void saveOnboardingData({
    required String tradingType,
    required String experienceLevel,
    required String tradingStyle,
    required bool isPropFirmTrader,
  }) {
    state = state.copyWith(
      tradingType: tradingType,
      experienceLevel: experienceLevel,
      tradingStyle: tradingStyle,
      isPropFirmTrader: isPropFirmTrader,
    );
  }

  void login({required String email, required String password}) {
    // Simple demo login - in production, validate against backend
    if (email.isNotEmpty && password.isNotEmpty) {
      state = state.copyWith(
        isLoggedIn: true,
        email: email,
        userName: email.split('@')[0].toUpperCase(),
      );
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
