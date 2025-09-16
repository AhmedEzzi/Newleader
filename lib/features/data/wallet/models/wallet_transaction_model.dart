import '../../../../core/utils/types/meta_response.dart';
import '../../../domain/wallet/entities/wallet_transaction.dart';

class WalletHistoryResponse {
  final List<WalletTransactionModel> data;
  final Meta meta;
  final bool result;
  final int status;

  WalletHistoryResponse({
    required this.data,
    required this.meta,
    required this.result,
    required this.status,
  });

  factory WalletHistoryResponse.fromJson(Map<String, dynamic> json) {
    return WalletHistoryResponse(
      data: (json['data'] as List).map((item) => WalletTransactionModel.fromJson(item)).toList(),
      meta: Meta.fromJson(json['meta']),
      result: json['result'] ?? false,
      status: json['status'] ?? 0,
    );
  }
}

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required String amount,
    required String paymentMethod,
    required String approvalString,
    required String date,
  }) : super(
          amount: amount,
          paymentMethod: paymentMethod,
          approvalString: approvalString,
          date: date,
        );

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      amount: json['amount'] ?? '0 L.E',
      paymentMethod: json['payment_method'] ?? 'N/A',
      approvalString: json['approval_string'] ?? 'N/A',
      date: json['date'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_method': paymentMethod,
      'approval_string': approvalString,
      'date': date,
    };
  }
} 