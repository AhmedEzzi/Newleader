
import '../../repositories/auth_repository.dart';

class ConfirmCodeUseCase {
  final AuthRepository authRepository;

  ConfirmCodeUseCase(this.authRepository);

  Future<void> call(String email, String code) async {
    await authRepository.confirmCode(email, code);
  }
}
