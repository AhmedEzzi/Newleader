class PaymentType {
  final String paymentType;
  final String paymentTypeKey;
  final String image;
  final String name;
  final String title;
  final int offlinePaymentId;
  final String details;

  PaymentType({
    required this.paymentType,
    required this.paymentTypeKey,
    required this.image,
    required this.name,
    required this.title,
    required this.offlinePaymentId,
    required this.details,
  });
}

class OrderResponse {
  final bool result;
  final String message;
  final CombinedOrder? combinedOrder;
  final String? checkoutUrl;
  final String status;

  OrderResponse({
    required this.result,
    required this.message,
    this.combinedOrder,
    this.checkoutUrl,
    required this.status,
  });
}

class CombinedOrder {
  final int id;
  final List<Order>? orders;

  CombinedOrder({
    required this.id,
    this.orders,
  });
}

class Order {
  final int id;
  final String code;
  final String paymentStatus;
  final String paymentType;

  Order({
    required this.id,
    required this.code,
    required this.paymentStatus,
    required this.paymentType
  });
}
