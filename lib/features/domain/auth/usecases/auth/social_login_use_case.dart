import '../../../../data/auth/models/auth_response_model.dart';
import '../../repositories/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository authRepository;

  SocialLoginUseCase(this.authRepository);

  Future<AuthResponseModel> call( {required String socialProvider,
  required String name,
  required String email,
  required String provider,
        access_token = "",
        secret_token = "",
      }) async {
    return await authRepository.socialLogin(socialProvider: socialProvider, name: name, email: email, provider: provider,access_token: access_token,secret_token: secret_token);
  }
}
