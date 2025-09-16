import '../entities/wallet_balance.dart';
import '../repositories/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository repository;

  GetWalletBalanceUseCase(this.repository);

  Future<WalletBalance> call() {
    return repository.getWalletBalance();
  }
} 