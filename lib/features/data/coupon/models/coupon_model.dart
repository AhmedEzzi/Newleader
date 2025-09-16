import '../../../domain/coupon/entities/coupon.dart';

class CouponModel {
  final bool success;
  final String message;
  final double? discountAmount;
  final String? couponCode;

  CouponModel({
    required this.success,
    required this.message,
    this.discountAmount,
    this.couponCode,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      success: json['result'] ?? false,
      message: json['message'] ?? '',
      // These fields might not be present in the response based on the examples
      // but we keep them optional for compatibility with existing code
      discountAmount: json['discount_amount'] != null 
          ? (json['discount_amount'] as num).toDouble() 
          : null,
      couponCode: json['coupon_code'],
    );
  }

  Coupon toEntity() {
    return Coupon(
      success: success,
      message: message,
      discountAmount: discountAmount,
      couponCode: couponCode,
    );
  }
}