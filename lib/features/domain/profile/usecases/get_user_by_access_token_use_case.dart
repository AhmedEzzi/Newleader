import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserByAccessTokenUseCase {
  final ProfileRepository _repository;

  GetUserByAccessTokenUseCase(this._repository);

  Future<UserProfile> call() async {
    final userProfileModel = await _repository.getUserByAccessToken();
    return userProfileModel.toEntity();
  }
}