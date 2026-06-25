import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final performanceProvider = StateNotifierProvider<PerformanceNotifier, bool>((ref) {
  return PerformanceNotifier();
});

class PerformanceNotifier extends StateNotifier<bool> {
  PerformanceNotifier() : super(true) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool('enableBlur') ?? true;
    } catch (_) {
      state = true;
    }
  }

  Future<void> setBlurEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('enableBlur', enabled);
      state = enabled;
    } catch (_) {
      state = enabled;
    }
  }
}
