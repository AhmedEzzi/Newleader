// lib/features/data/order/models/order_items_model.dart
import '../../../domain/order/entities/order_item.dart';

class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String variation;
  final String price;
  final String tax;
  final String shippingCost;
  final String couponDiscount;
  final int quantity;
  final String paymentStatus;
  final String paymentStatusString;
  final String deliveryStatus;
  final String deliveryStatusString;
  final bool refundSection;
  final bool refundButton;
  final String refundLabel;
  final int refundRequestStatus;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.variation,
    required this.price,
    required this.tax,
    required this.shippingCost,
    required this.couponDiscount,
    required this.quantity,
    required this.paymentStatus,
    required this.paymentStatusString,
    required this.deliveryStatus,
    required this.deliveryStatusString,
    required this.refundSection,
    required this.refundButton,
    required this.refundLabel,
    required this.refundRequestStatus,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      variation: json['variation'] ?? '',
      price: json['price'] ?? '',
      tax: json['tax'] ?? '',
      shippingCost: json['shipping_cost'] ?? '',
      couponDiscount: json['coupon_discount'] ?? '',
      quantity: json['quantity'] ?? 0,
      paymentStatus: json['payment_status'] ?? '',
      paymentStatusString: json['payment_status_string'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      deliveryStatusString: json['delivery_status_string'] ?? '',
      refundSection: json['refund_section'] ?? false,
      refundButton: json['refund_button'] ?? false,
      refundLabel: json['refund_label'] ?? '',
      refundRequestStatus: json['refund_request_status'] ?? 0,
    );
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      productId: productId,
      productName: productName,
      variation: variation,
      price: price,
      quantity: quantity,
      paymentStatus: paymentStatus,
      paymentStatusString: paymentStatusString,
      deliveryStatus: deliveryStatus,
      deliveryStatusString: deliveryStatusString,
    );
  }
}

class OrderItemsResponse {
  final List<OrderItemModel> data;
  final bool success;
  final int status;

  OrderItemsResponse({
    required this.data,
    required this.success,
    required this.status,
  });

  factory OrderItemsResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemsResponse(
      data: (json['data'] as List?)
          ?.map((item) => OrderItemModel.fromJson(item))
          .toList() ??
          [],
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }
}