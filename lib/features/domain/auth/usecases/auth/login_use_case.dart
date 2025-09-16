import '../../../../../core/utils/results.dart';
import '../../../../data/auth/models/auth_response_model.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Result<AuthResponseModel>> call(String email, String password, String loginBy) async {
    return await authRepository.login(email, password, loginBy);
  }
}