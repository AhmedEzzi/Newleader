import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<UserProfile> call() async {
    final userProfileModel = await _repository.getUserProfile();
    return userProfileModel.toEntity();
  }
}
