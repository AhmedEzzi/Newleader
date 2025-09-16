import '../entities/coupon.dart';

abstract class CouponRepository {
  Future<Coupon> applyCoupon(String couponCode);
  Future<Coupon> removeCoupon();
}

