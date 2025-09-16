import 'package:flutter/material.dart';
import '../entities/payment_type.dart';

abstract class PaymentRepository {
  /// Get available checkout types
  Future<List<PaymentType>> getPaymentTypes();
  
  /// Create a Kashier checkout order
  Future<OrderResponse> createKashierOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    BuildContext? context,
  });
  
  /// Create a Cash on Delivery checkout order
  Future<OrderResponse> createCashOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  });
  
  /// Create a Wallet payment order
  Future<OrderResponse> createWalletOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  });
  
  /// Verify order success by order ID
  Future<Map<String, dynamic>> verifyOrderSuccess(String orderId);

  Future<Map<String, dynamic>> updateShippingTypeInCart({
    required int stateId,
    required String address,
  });
}
