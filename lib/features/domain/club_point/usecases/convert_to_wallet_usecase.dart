import '../repositories/club_point_repository.dart';

class ConvertToWalletUseCase {
  final ClubPointRepository repository;

  ConvertToWalletUseCase(this.repository);

  Future<bool> call() {
    return repository.convertToWallet();
  }
} 