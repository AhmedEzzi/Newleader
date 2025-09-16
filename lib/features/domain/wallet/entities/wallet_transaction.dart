import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  final String amount;
  final String paymentMethod;
  final String approvalString;
  final String date;

  const WalletTransaction({
    required this.amount,
    required this.paymentMethod,
    required this.approvalString,
    required this.date,
  });

  @override
  List<Object?> get props => [amount, paymentMethod, approvalString, date];
} 