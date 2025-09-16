import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class GetWalletHistoryUseCase {
  final WalletRepository repository;

  GetWalletHistoryUseCase(this.repository);

  Future<List<WalletTransaction>> call({int page = 1}) {
    return repository.getWalletHistory(page: page);
  }
} 