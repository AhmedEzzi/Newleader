import '../../../domain/wallet/entities/wallet_balance.dart';

class WalletBalanceModel extends WalletBalance {
  const WalletBalanceModel({
    required String balance,
    required String lastRecharged,
  }) : super(
          balance: balance,
          lastRecharged: lastRecharged,
        );

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      balance: json['balance'] ?? '0 L.E',
      lastRecharged: json['last_recharged'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'last_recharged': lastRecharged,
    };
  }
} 