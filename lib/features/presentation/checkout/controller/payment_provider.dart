import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/payment/entities/payment_type.dart';
import '../../../domain/payment/usecases/get_payment_types_usecase.dart';
import '../../../domain/payment/usecases/create_kashier_order_usecase.dart';
import '../../../domain/payment/usecases/create_cash_order_usecase.dart';
import '../../../domain/payment/usecases/create_wallet_order_usecase.dart';
import '../../../domain/payment/usecases/verify_order_success_usecase.dart';
import '../../../domain/payment/usecases/update_shipping_type_usecase.dart';

class PaymentProvider extends ChangeNotifier {
  final GetPaymentTypesUseCase getPaymentTypesUseCase;
  final CreateKashierOrderUseCase createKashierOrderUseCase;
  final CreateCashOrderUseCase createCashOrderUseCase;
  final CreateWalletOrderUseCase createWalletOrderUseCase;
  final VerifyOrderSuccessUseCase verifyOrderSuccessUseCase;
  final UpdateShippingTypeUseCase updateShippingTypeUseCase;

  PaymentProvider({
    required this.getPaymentTypesUseCase,
    required this.createKashierOrderUseCase,
    required this.createCashOrderUseCase,
    required this.createWalletOrderUseCase,
    required this.verifyOrderSuccessUseCase,
    required this.updateShippingTypeUseCase,
  });

  LoadingState paymentTypesState = LoadingState.initial;
  LoadingState orderCreationState = LoadingState.initial;
  LoadingState shippingUpdateState = LoadingState.initial;
  List<PaymentType> paymentTypes = [];
  String selectedPaymentTypeKey = '';
  String errorMessage = '';

  Future<void> fetchPaymentTypes() async {
    try {
      paymentTypesState = LoadingState.loading;
      notifyListeners();

      paymentTypes = await getPaymentTypesUseCase();

      if (paymentTypes.isNotEmpty && selectedPaymentTypeKey.isEmpty) {
        selectedPaymentTypeKey = paymentTypes.first.paymentTypeKey;
      }

      paymentTypesState = LoadingState.loaded;
    } catch (e) {
      paymentTypesState = LoadingState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void selectPaymentType(String paymentTypeKey) {
    selectedPaymentTypeKey = paymentTypeKey;
    notifyListeners();
  }

  Future<OrderResponse> createOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    try {
      orderCreationState = LoadingState.loading;
      notifyListeners();

      late OrderResponse response;
      print('sssss$selectedPaymentTypeKey');

      if (selectedPaymentTypeKey == 'kashier') {
        response = await createKashierOrderUseCase(
          postalCode: postalCode,
          stateId: stateId,
          address: address,
          city: city,
          phone: phone,
          additionalInfo: additionalInfo,
          context: context,
        );
      } else if (selectedPaymentTypeKey == 'cash_on_delivery') {
        response = await createCashOrderUseCase(
          postalCode: postalCode,
          stateId: stateId,
          address: address,
          city: city,
          phone: phone,
          additionalInfo: additionalInfo,
          context: context,
        );
      } else if (selectedPaymentTypeKey == 'wallet') {
        response = await createWalletOrderUseCase(
          postalCode: postalCode,
          stateId: stateId,
          address: address,
          city: city,
          phone: phone,
          additionalInfo: additionalInfo,
          context: context,
        );
      } else {
        throw Exception('Invalid checkout method selected');
      }

      orderCreationState = response.result ? LoadingState.loaded : LoadingState.error;
      if (!response.result) {
        errorMessage = response.message;
      }


      return response;
    } catch (e) {
      orderCreationState = LoadingState.error;
      errorMessage = e.toString();
      return OrderResponse(
        result: false,
        message: e.toString(),
        status: 'error',
      );
    } finally {
      notifyListeners();
    }
  }


  Future<Map<String, dynamic>> verifyOrder(String orderId) async {
    try {
      return await verifyOrderSuccessUseCase(orderId);
    } catch (e) {
      errorMessage = e.toString();
      return {
        'result': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateShippingTypeForGuest({
    required int stateId,
    required String address,
  }) async {
    try {
      shippingUpdateState = LoadingState.loading;
      notifyListeners();

      final result = await updateShippingTypeUseCase(
        stateId: stateId,
        address: address,
      );

      shippingUpdateState = result['result'] == true ?
      LoadingState.loaded : LoadingState.error;

      if (result['result'] != true && result['message'] != null) {
        errorMessage = result['message'].toString();
      }

      return result;
    } catch (e) {
      shippingUpdateState = LoadingState.error;
      errorMessage = e.toString();
      return {
        'result': false,
        'message': e.toString(),
      };
    } finally {
      notifyListeners();
    }
  }

  PaymentType? getSelectedPaymentType() {
    if (selectedPaymentTypeKey.isEmpty) return null;

    try {
      return paymentTypes.firstWhere(
              (type) => type.paymentTypeKey == selectedPaymentTypeKey
      );
    } catch (e) {
      return null;
    }
  }

  void resetOrderCreationState() {
    orderCreationState = LoadingState.initial;
    errorMessage = '';
    notifyListeners();
  }

  void resetShippingUpdateState() {
    shippingUpdateState = LoadingState.initial;
    errorMessage = '';
    notifyListeners();
  }
}