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
    final profile = await IsarService.isar.userProfiles.where().findFirst();
    if (profile == null) {
      // Create default profile if not exists
      final newProfile = UserProfile();
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.userProfiles.put(newProfile);
      });
      state = newProfile;
    } else {
      state = profile;
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userProfiles.put(updatedProfile);
    });
    state = updatedProfile;
  }
}
