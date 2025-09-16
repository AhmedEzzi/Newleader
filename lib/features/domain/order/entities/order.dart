class Order {
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

  Order({
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
}