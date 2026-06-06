import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/user_profile.dart';
import '../../core/services/isar_service.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<UserProfile?> {
  ProfileNotifier() : super(null) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final isar = await IsarService.getInstance();
      final profile = await isar.userProfiles.where().findFirst();
      if (profile == null) {
        // Create default profile if not exists
        final newProfile = UserProfile();
        await isar.writeTxn(() async {
          await isar.userProfiles.put(newProfile);
        });
        state = newProfile;
      } else {
        state = profile;
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await isar.userProfiles.put(updatedProfile);
      });
      state = updatedProfile;
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
