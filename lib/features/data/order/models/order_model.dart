// lib/features/data/order/models/order_model.dart
import '../../../domain/order/entities/order.dart';

class OrderModel {
  final int id;
  final String code;
  final int userId;
  final String paymentType;
  final String paymentStatus;
  final String paymentStatusString;
  final String deliveryStatus;
  final String deliveryStatusString;
  final String grandTotal;
  final String date;
  final Map<String, dynamic> links;

  OrderModel({
    required this.id,
    required this.code,
    required this.userId,
    required this.paymentType,
    required this.paymentStatus,
    required this.paymentStatusString,
    required this.deliveryStatus,
    required this.deliveryStatusString,
    required this.grandTotal,
    required this.date,
    required this.links,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      userId: json['user_id'] ?? 0,
      paymentType: json['payment_type'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentStatusString: json['payment_status_string'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      deliveryStatusString: json['delivery_status_string'] ?? '',
      grandTotal: json['grand_total'] ?? '',
      date: json['date'] ?? '',
      links: json['links'] ?? {},
    );
  }

  Order toEntity() {
    return Order(
      id: id,
      code: code,
      userId: userId,
      paymentType: paymentType,
      paymentStatus: paymentStatus,
      paymentStatusString: paymentStatusString,
      deliveryStatus: deliveryStatus,
      deliveryStatusString: deliveryStatusString,
      grandTotal: grandTotal,
      date: date,
      links: links,
    );
  }
}

class OrderResponse {
  final List<OrderModel> data;
  final Map<String, dynamic> links; // Changed from Map<String, String> to Map<String, dynamic>
  final Map<String, dynamic> meta;
  final bool success;
  final int status;

  OrderResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      data: (json['data'] as List?)
          ?.map((order) => OrderModel.fromJson(order))
          .toList() ??
          [],
      // Fix: Safe handling for links, allowing null values
      links: json['links'] as Map<String, dynamic>? ?? {},
      meta: json['meta'] as Map<String, dynamic>? ?? {},
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
    );
  }
}