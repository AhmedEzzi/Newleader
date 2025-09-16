import '../../../domain/profile/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_counters_model.dart';
import '../models/profile_update_response.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfileModel> getUserProfile() async {
    return await remoteDataSource.getUserProfile();
  }

  @override
  Future<ProfileCountersModel> getProfileCounters() async {
    return await remoteDataSource.getProfileCounters();
  }

  @override
  Future<ProfileUpdateResponse> updateProfile(String userId, String name, String password) async {
    return await remoteDataSource.updateProfile(userId, name, password);
  }

  @override
  Future<ProfileUpdateResponse> updateProfileImage(String userId, String filename, String base64Image) async {
    return await remoteDataSource.updateProfileImage(userId, filename, base64Image);
  }

  @override
  Future<UserProfileModel> getUserByAccessToken() async {
    return await remoteDataSource.getUserByAccessToken();
  }
}
