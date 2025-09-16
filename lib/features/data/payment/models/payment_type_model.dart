import '../../../domain/payment/entities/payment_type.dart';

class PaymentTypeModel extends PaymentType {
  PaymentTypeModel({
    required String paymentType,
    required String paymentTypeKey,
    required String image,
    required String name,
    required String title,
    required int offlinePaymentId,
    required String details,
  }) : super(
          paymentType: paymentType,
          paymentTypeKey: paymentTypeKey,
          image: image,
          name: name,
          title: title,
          offlinePaymentId: offlinePaymentId,
          details: details,
        );

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeModel(
      paymentType: json['payment_type'] ?? '',
      paymentTypeKey: json['payment_type_key'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      offlinePaymentId: json['offline_payment_id'] ?? 0,
      details: json['details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_type': paymentType,
      'payment_type_key': paymentTypeKey,
      'image': image,
      'name': name,
      'title': title,
      'offline_payment_id': offlinePaymentId,
      'details': details,
    };
  }
}

class OrderResponseModel extends OrderResponse {
  OrderResponseModel({
    required bool result,
    required String message,
    CombinedOrderModel? combinedOrder,
    String? checkoutUrl,
    required String status,
  }) : super(
          result: result,
          message: message,
          combinedOrder: combinedOrder,
          checkoutUrl: checkoutUrl,
          status: status,
        );

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      result: json['result'] ?? false,
      message: json['message'] ?? '',
      combinedOrder: json['combined_order'] != null
          ? CombinedOrderModel.fromJson(json['combined_order'])
          : null,
      checkoutUrl: json['checkout_url'],
      status: json['status'] ?? '',
    );
  }
}

class CombinedOrderModel extends CombinedOrder {
  CombinedOrderModel({
    required int id,
    List<OrderModel>? orders,
  }) : super(
          id: id,
          orders: orders,
        );

  factory CombinedOrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderModel>? ordersList;
    if (json['orders'] != null) {
      ordersList = <OrderModel>[];
      json['orders'].forEach((v) {
        ordersList!.add(OrderModel.fromJson(v));
      });
    }

    return CombinedOrderModel(
      id: json['id'] ?? 0,
      orders: ordersList,
    );
  }
}

class OrderModel extends Order {
  OrderModel({
    required int id,
    required String code,
    required String paymentStatus,
    required String paymentType,
  }) : super(
          id: id,
          code: code,
          paymentStatus: paymentStatus,
    paymentType: paymentType
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentType: json['payment_type']??''
    );
  }
}
