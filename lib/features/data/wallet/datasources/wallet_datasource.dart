import '../../../../core/api/api_provider.dart';
import '../models/wallet_balance_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletDataSource {
  Future<WalletBalanceModel> getWalletBalance();
  Future<WalletHistoryResponse> getWalletHistory({int page = 1});
}

class WalletDataSourceImpl implements WalletDataSource {
  final ApiProvider apiProvider;

  WalletDataSourceImpl(this.apiProvider);

  @override
  Future<WalletBalanceModel> getWalletBalance() async {
    try {
      final response = await apiProvider.get('/wallet/balance');
      return WalletBalanceModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load wallet balance: $e');
    }
  }

  @override
  Future<WalletHistoryResponse> getWalletHistory({int page = 1}) async {
    try {
      final response = await apiProvider.get(
        '/wallet/history',
        queryParameters: {'page': page},
      );
      return WalletHistoryResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load wallet history: $e');
    }
  }
} 