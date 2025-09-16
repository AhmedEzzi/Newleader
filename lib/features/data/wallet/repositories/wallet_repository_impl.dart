import '../../../../core/network/network_info.dart';
import '../../../domain/wallet/entities/wallet_balance.dart';
import '../../../domain/wallet/entities/wallet_transaction.dart';
import '../../../domain/wallet/repositories/wallet_repository.dart';
import '../datasources/wallet_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource dataSource;
  final NetworkInfo networkInfo;

  WalletRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<WalletBalance> getWalletBalance() async {
    if (await networkInfo.isConnected) {
      return await dataSource.getWalletBalance();
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<List<WalletTransaction>> getWalletHistory({int page = 1}) async {
    if (await networkInfo.isConnected) {
      final response = await dataSource.getWalletHistory(page: page);
      return response.data;
    } else {
      throw Exception('No internet connection');
    }
  }
} 