// lib/features/data/order/models/order_details_model.dart
import '../../../domain/order/entities/order_details.dart';

class OrderDetailsModel {
  final int id;
  final String code;
  final int userId;
  final Map<String, dynamic> shippingAddress;
  final String paymentType;
  final dynamic pickupPoint;
  final String shippingType;
  final String shippingTypeString;
  final String paymentStatus;
  final String paymentStatusString;
  final String deliveryStatus;
  final String deliveryStatusString;
  final String grandTotal;
  final double planeGrandTotal;
  final String couponDiscount;
  final String shippingCost;
  final String subtotal;
  final String tax;
  final String date;
  final bool cancelRequest;
  final bool manuallyPayable;
  final Map<String, dynamic> links;

  OrderDetailsModel({
    required this.id,
    required this.code,
    required this.userId,
    required this.shippingAddress,
    required this.paymentType,
    required this.pickupPoint,
    required this.shippingType,
    required this.shippingTypeString,
    required this.paymentStatus,
    required this.paymentStatusString,
    required this.deliveryStatus,
    required this.deliveryStatusString,
    required this.grandTotal,
    required this.planeGrandTotal,
    required this.couponDiscount,
    required this.shippingCost,
    required this.subtotal,
    required this.tax,
    required this.date,
    required this.cancelRequest,
    required this.manuallyPayable,
    required this.links,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      userId: json['user_id'] ?? 0,
      shippingAddress: json['shipping_address'] ?? {},
      paymentType: json['payment_type'] ?? '',
      pickupPoint: json['pickup_point'],
      shippingType: json['shipping_type'] ?? '',
      shippingTypeString: json['shipping_type_string'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentStatusString: json['payment_status_string'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      deliveryStatusString: json['delivery_status_string'] ?? '',
      grandTotal: json['grand_total'] ?? '',
      planeGrandTotal: (json['plane_grand_total'] as num?)?.toDouble() ?? 0.0,
      couponDiscount: json['coupon_discount'] ?? '',
      shippingCost: json['shipping_cost'] ?? '',
      subtotal: json['subtotal'] ?? '',
      tax: json['tax'] ?? '',
      date: json['date'] ?? '',
      cancelRequest: json['cancel_request'] ?? false,
      manuallyPayable: json['manually_payable'] ?? false,
      links: json['links'] ?? {},
    );
  }

  OrderDetails toEntity() {
    return OrderDetails(
      id: id,
      code: code,
      userId: userId,
      shippingAddress: ShippingAddress.fromJson(shippingAddress),
      paymentType: paymentType,
      paymentStatus: paymentStatus,
      paymentStatusString: paymentStatusString,
      deliveryStatus: deliveryStatus,
      deliveryStatusString: deliveryStatusString,
      grandTotal: grandTotal,
      planeGrandTotal: planeGrandTotal,
      couponDiscount: couponDiscount,
      shippingCost: shippingCost,
      subtotal: subtotal,
      tax: tax,
      date: date,
      cancelRequest: cancelRequest,
    );
  }
}

class OrderDetailsResponse {
  final List<OrderDetailsModel> data;
  final bool success;
  final int status;

  OrderDetailsResponse({
    required this.data,
    required this.success,
    required this.status,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      data: (json['data'] as List?)
          ?.map((order) => OrderDetailsModel.fromJson(order))
          .toList() ??
          [],
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }
}