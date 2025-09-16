
import '../../repositories/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository authRepository;

  ForgetPasswordUseCase(this.authRepository);

  Future<void> call(String email) async {
    await authRepository.forgetPassword(email);
  }
}
