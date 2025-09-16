import 'package:equatable/equatable.dart';

class WalletBalance extends Equatable {
  final String balance;
  final String lastRecharged;

  const WalletBalance({
    required this.balance,
    required this.lastRecharged,
  });

  @override
  List<Object?> get props => [balance, lastRecharged];
} 