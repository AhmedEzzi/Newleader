import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../presentation/checkout/screens/success_screen.dart';
import '../../../presentation/checkout/screens/web_view_page.dart';
import '../models/payment_type_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentTypeModel>> getPaymentTypes();
  Future<OrderResponseModel> createKashierOrder({
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String postalCode,
    String? additionalInfo,
    BuildContext? context,
  });
  Future<OrderResponseModel> createCashOrder({
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String postalCode,
    String? additionalInfo,
    required BuildContext context,
  });
  Future<OrderResponseModel> createWalletOrder({
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String postalCode,
    String? additionalInfo,
    required BuildContext context,
  });
  Future<Map<String, dynamic>> verifyOrderSuccess(String orderId);

  // New function
  Future<Map<String, dynamic>> updateShippingTypeInCart({
    required int stateId,
    required String address,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiProvider apiProvider;

  PaymentRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<List<PaymentTypeModel>> getPaymentTypes() async {
    try {
      final response = await apiProvider.get(LaravelApiEndPoint.paymentTypes);

      if (response.data != null) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => PaymentTypeModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load checkout types: Invalid response format',
        );
      }
    } catch (e) {
      throw Exception('Failed to load checkout types: $e');
    }
  }

  @override
  Future<OrderResponseModel> createKashierOrder({
    required String stateId,
    required String address,
    required String city,
    required String postalCode,
    required String phone,
    String? additionalInfo,
    BuildContext? context,
  }) async {
    try {
      final data = {
        "name": AppStrings.userName,
        "email": AppStrings.userEmail??'',
        "address": address,
        "country": 'egypt',
        "state_id": stateId,
        "city": city,
        "postal_code" : postalCode,
        "phone": phone,
        "payment_type": 'kashier',
        "order_from": 'mobile',
        "additional_info": additionalInfo ?? "",
        if (AppStrings.userId==null) "temp_user_id": AppStrings.tempUserId,
        if (AppStrings.userId != null) "user_id": AppStrings.userId,
      };
      print(data);

      final response = await apiProvider.post(
        LaravelApiEndPoint.orderStore,
        data: data,
      );

      print("Raw response from /order/store: ${response.data}");
      final orderResponse = OrderResponseModel.fromJson(response.data);

      if (orderResponse.status == 'success' &&
          orderResponse.checkoutUrl != null &&
          context != null) {
        final checkoutUrl = orderResponse.checkoutUrl!;
        print("Checkout URL: $checkoutUrl");

        final webViewResult = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url: checkoutUrl),
          ),
        );

        if (webViewResult is String) {
          print("WebView result: $webViewResult");
          final uri = Uri.parse(webViewResult);
          final paymentStatus = uri.queryParameters['paymentStatus'];
          final merchantOrderId = uri.queryParameters['merchantOrderId'];

          if (paymentStatus == 'SUCCESS' && merchantOrderId != null) {
            final verificationResult = await verifyOrderSuccess(merchantOrderId);
            print("Verification result: $verificationResult");

            if (verificationResult['result'] == true &&
                verificationResult['combined_order'] != null &&
                verificationResult['combined_order']['orders'] != null &&
                verificationResult['combined_order']['orders'][0]['payment_status'] == 'paid') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  SuccessScreen(orderDetails: orderResponse)),
              );
              return OrderResponseModel(
                result: true,
                message: 'Payment successful',
                status: 'success',
              );
            } else {
              // Handle verification failure
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment verification failed')),
              );
            }
          } else if (paymentStatus == 'FAILED') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment failed')),
            );
          }
        } else {
          // Handle case where WebViewResult is null or not a string
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment process was interrupted')),
          );
        }

        return OrderResponseModel(
          result: false,
          message: 'Payment process incomplete',
          status: 'error',
        );
      }

      return orderResponse;
    } catch (e) {
      print("Error in createKashierOrder: $e");
      return OrderResponseModel(
        result: false,
        message: 'An error occurred: $e',
        status: 'error',
      );
    }
  }

  @override
  Future<OrderResponseModel> createCashOrder({
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String postalCode,
    String? additionalInfo,
    required BuildContext context,
  }) async {

    try {

      final data = {
        "name": AppStrings.userName,
        "email": AppStrings.userEmail??'',
        "address": address,
        "country": 'egypt',
        "state_id": stateId,
        "city": city,
        "postal_code" : postalCode,
        "phone": phone,
        "payment_type": 'cash_payment',
        "order_from": 'mobile',
        "additional_info": additionalInfo ?? "",
        if (AppStrings.userId==null) "temp_user_id": AppStrings.tempUserId,
        if (AppStrings.userId != null) "user_id": AppStrings.userId,
      };


      final response = await apiProvider.post(
        LaravelApiEndPoint.orderStore,
        data: data,
      );

      print("Raw response from /order/store: ${response.data}");


      final orderResponse = OrderResponseModel.fromJson(response.data);

      // Check if order was created successfully
      if (orderResponse.result && orderResponse.combinedOrder != null) {

        final verificationResult = await verifyOrderSuccess(orderResponse.combinedOrder!.id.toString());
        print("Verification result: $verificationResult");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  SuccessScreen(orderDetails: orderResponse)),
        );

        return OrderResponseModel(
          result: true,
          message: 'Cash order created successfully',
          status: 'success',
          combinedOrder: orderResponse.combinedOrder as CombinedOrderModel?,
        );
      }

      return orderResponse;
    } catch (e) {


      print("Error in createCashOrder: $e");
      return OrderResponseModel(
        result: false,
        message: 'An error occurred while creating cash order: $e',
        status: 'error',
      );
    }
  }

  @override
  Future<OrderResponseModel> createWalletOrder({
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String postalCode,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    try {

      final data = {
        "name": AppStrings.userName,
        "email": AppStrings.userEmail??'',
        "address": address,
        "country": 'egypt',
        "state_id": stateId,
        "city": city,
        "postal_code" : postalCode,
        "phone": phone,
        "payment_type": 'wallet',
        "order_from": 'mobile',
        "additional_info": additionalInfo ?? "",
        if (AppStrings.userId==null) "temp_user_id": AppStrings.tempUserId,
        if (AppStrings.userId != null) "user_id": AppStrings.userId,
      };


      final response = await apiProvider.post(
        LaravelApiEndPoint.orderStore,
        data: data,
      );



      final orderResponse = OrderResponseModel.fromJson(response.data);

      // Check if order was created successfully
      if (orderResponse.result && orderResponse.combinedOrder != null) {
        final verificationResult = await verifyOrderSuccess(orderResponse.combinedOrder!.id.toString());
        print("Verification result: $verificationResult");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessScreen(orderDetails: orderResponse)),
        );

        return OrderResponseModel(
          result: true,
          message: 'Wallet payment successful',
          status: 'success',
          combinedOrder: orderResponse.combinedOrder as CombinedOrderModel?,
        );
      }

      return orderResponse;
    } catch (e) {
      // Ensure loading dialog is closed in case of error
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      print("Error in createWalletOrder: $e");
      return OrderResponseModel(
        result: false,
        message: 'An error occurred while processing wallet payment: $e',
        status: 'error',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOrderSuccess(String orderId) async {
    try {
      print("Verifying order: $orderId");
      final response = await apiProvider.get(
        "${LaravelApiEndPoint.orderDetails}/$orderId",
      );

      print("Raw response from /order-details: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error in verifyOrderSuccess: $e");
      return {"result": false, "message": "Verification failed: $e"};
    }
  }


  @override
  Future<Map<String, dynamic>> updateShippingTypeInCart({
    required int stateId,
    required String address,
  }) async {
    try {
      const String shippingType = "home_delivery";
      const int shippingId = 123;

      final data = {
        if (AppStrings.userId==null) "temp_user_id": AppStrings.tempUserId,
        if (AppStrings.userId != null) "user_id": AppStrings.userId,
        "address": address,
        "shipping_type": shippingType,
        "shipping_id": shippingId.toString(),
        "country_id": 64,
        "state_id": stateId
      };

      print("Updating shipping type in cart");
      print("Request Body: $data");

      final response = await apiProvider.post(
        LaravelApiEndPoint.updateShippingTypeInCart,
        data: data,
      );

      print("Response Body: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error in updateShippingTypeInCart: $e");
      return {"result": false, "message": "Failed to update shipping type: $e"};
    }
  }

}
