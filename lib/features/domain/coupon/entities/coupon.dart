class Coupon {
  final bool success;
  final String message;
  final double? discountAmount;
  final String? couponCode;

  Coupon({
    required this.success,
    required this.message,
    this.discountAmount,
    this.couponCode,
  });
}