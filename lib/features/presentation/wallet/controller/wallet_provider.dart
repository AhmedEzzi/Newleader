import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/wallet/entities/wallet_balance.dart';
import '../../../domain/wallet/entities/wallet_transaction.dart';
import '../../../domain/wallet/usecases/get_wallet_balance_usecase.dart';
import '../../../domain/wallet/usecases/get_wallet_history_usecase.dart';

class WalletProvider extends ChangeNotifier {
  final GetWalletBalanceUseCase getWalletBalanceUseCase;
  final GetWalletHistoryUseCase getWalletHistoryUseCase;

  WalletBalance? walletBalance;
  List<WalletTransaction> transactions = [];
  LoadingState balanceState = LoadingState.initial;
  LoadingState historyState = LoadingState.initial;
  String errorMessage = '';
  int currentPage = 1;
  bool hasMoreTransactions = true;

  WalletProvider({
    required this.getWalletBalanceUseCase,
    required this.getWalletHistoryUseCase,
  });

  Future<void> fetchWalletBalance() async {
    try {
      balanceState = LoadingState.loading;
      notifyListeners();

      walletBalance = await getWalletBalanceUseCase();
      
      balanceState = LoadingState.loaded;
    } catch (e) {
      balanceState = LoadingState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchWalletHistory({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMoreTransactions = true;
      transactions = [];
    }

    if (!hasMoreTransactions) return;

    try {
      historyState = LoadingState.loading;
      notifyListeners();

      final history = await getWalletHistoryUseCase(page: currentPage);
      
      if (history.isEmpty) {
        hasMoreTransactions = false;
      } else {
        transactions.addAll(history);
        currentPage++;
      }
      
      historyState = LoadingState.loaded;
    } catch (e) {
      historyState = LoadingState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshWallet() async {
    await fetchWalletBalance();
    await fetchWalletHistory(refresh: true);
  }
} 