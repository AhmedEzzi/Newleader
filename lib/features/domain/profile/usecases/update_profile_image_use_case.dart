import '../../../data/profile/models/profile_update_response.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository _repository;

  UpdateProfileImageUseCase(this._repository);

  Future<ProfileUpdateResponse> call(String userId, String filename, String base64Image) async {
    return await _repository.updateProfileImage(userId, filename, base64Image);
  }
}
