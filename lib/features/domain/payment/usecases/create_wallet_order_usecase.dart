import 'package:flutter/material.dart';
import '../entities/payment_type.dart';
import '../repositories/payment_repository.dart';

class CreateWalletOrderUseCase {
  final PaymentRepository repository;

  CreateWalletOrderUseCase(this.repository);

  Future<OrderResponse> call({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    return await repository.createWalletOrder(
      postalCode: postalCode,
      stateId: stateId,
      address: address,
      city: city,
      phone: phone,
      additionalInfo: additionalInfo,
      context: context,
    );
  }
} 