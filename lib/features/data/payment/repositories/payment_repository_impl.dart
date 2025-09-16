import 'package:flutter/material.dart';
import '../../../domain/payment/entities/payment_type.dart';
import '../../../domain/payment/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PaymentType>> getPaymentTypes() async {
    try {
      final paymentTypes = await remoteDataSource.getPaymentTypes();
      return paymentTypes;
    } catch (e) {
      throw Exception('Failed to get checkout types: $e');
    }
  }

  @override
  Future<OrderResponse> createKashierOrder({
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String postalCode,
    String? additionalInfo,
    BuildContext? context,
  }) async {
    try {
      final orderResponse = await remoteDataSource.createKashierOrder(
        stateId: stateId,
        address: address,
        city: city,
        phone: phone,
        additionalInfo: additionalInfo,
        context: context, postalCode: postalCode,
      );
      return orderResponse;
    } catch (e) {
      throw Exception('Failed to create Kashier order: $e');
    }
  }

  @override
  Future<OrderResponse> createCashOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    try {
      final orderResponse = await remoteDataSource.createCashOrder(
        stateId: stateId,
        address: address,
        city: city,
        phone: phone,
        additionalInfo: additionalInfo,
        context: context,
        postalCode: postalCode,
      );
      return orderResponse;
    } catch (e) {
      throw Exception('Failed to create Cash order: $e');
    }
  }

  @override
  Future<OrderResponse> createWalletOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    try {
      final orderResponse = await remoteDataSource.createWalletOrder(
        stateId: stateId,
        address: address,
        city: city,
        phone: phone,
        additionalInfo: additionalInfo,
        context: context,
        postalCode: postalCode,
      );
      return orderResponse;
    } catch (e) {
      throw Exception('Failed to create Wallet order: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOrderSuccess(String orderId) async {
    try {
      final verificationResult = await remoteDataSource.verifyOrderSuccess(orderId);
      return verificationResult;
    } catch (e) {
      throw Exception('Failed to verify order: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateShippingTypeInCart({
    required int stateId,
    required String address,
  }) async {
    try {
      final result = await remoteDataSource.updateShippingTypeInCart(
        stateId: stateId,
        address: address,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to update shipping type in cart: $e');
    }
  }
}
