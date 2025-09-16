import 'package:flutter/material.dart';
import '../entities/payment_type.dart';
import '../repositories/payment_repository.dart';

class CreateCashOrderUseCase {
  final PaymentRepository repository;

  CreateCashOrderUseCase(this.repository);

  Future<OrderResponse> call({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    return await repository.createCashOrder(
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
