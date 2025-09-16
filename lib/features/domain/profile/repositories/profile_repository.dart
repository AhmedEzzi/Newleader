import '../../../data/profile/models/profile_counters_model.dart';
import '../../../data/profile/models/profile_update_response.dart';
import '../../../data/profile/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile();
  Future<ProfileCountersModel> getProfileCounters();
  Future<ProfileUpdateResponse> updateProfile(String userId, String name, String password);
  Future<ProfileUpdateResponse> updateProfileImage(String userId, String filename, String base64Image);
  Future<UserProfileModel> getUserByAccessToken();

}
