import '../../../data/profile/models/profile_update_response.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<ProfileUpdateResponse> call(String userId, String name, String password) async {
    return await _repository.updateProfile(userId, name, password);
  }
}
