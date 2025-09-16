class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String variation;
  final String price;
  final int quantity;
  final String paymentStatus;
  final String paymentStatusString;
  final String deliveryStatus;
  final String deliveryStatusString;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.variation,
    required this.price,
    required this.quantity,
    required this.paymentStatus,
    required this.paymentStatusString,
    required this.deliveryStatus,
    required this.deliveryStatusString,
  });
}