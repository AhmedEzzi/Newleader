import '../../repositories/auth_repository.dart';

class ResendCodeUseCase {
  final AuthRepository authRepository;

  ResendCodeUseCase(this.authRepository);

  Future<void> call(String email) async {
    await authRepository.resendCode(email);
  }
}
