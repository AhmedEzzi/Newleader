
import '../../repositories/auth_repository.dart';

class ConfirmResetPasswordUseCase {
  final AuthRepository authRepository;

  ConfirmResetPasswordUseCase(this.authRepository);

  Future<void> call(String email, String code, String password) async {
    await authRepository.confirmResetPassword(email, code, password);
  }
}
