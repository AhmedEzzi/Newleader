import '../entities/coupon.dart';
import '../repositories/coupon_repository.dart';

class ApplyCouponUseCase {
  final CouponRepository repository;

  ApplyCouponUseCase(this.repository);

  Future<Coupon> call(String couponCode) async {
    return await repository.applyCoupon(couponCode);
  }
}