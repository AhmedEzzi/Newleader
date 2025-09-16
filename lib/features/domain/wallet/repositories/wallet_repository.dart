import '../entities/wallet_balance.dart';
import '../entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<WalletBalance> getWalletBalance();
  Future<List<WalletTransaction>> getWalletHistory({int page = 1});
} 