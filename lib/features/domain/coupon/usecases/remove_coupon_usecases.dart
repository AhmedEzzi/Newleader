import '../entities/coupon.dart';
import '../repositories/coupon_repository.dart';

class RemoveCouponUseCase {
  final CouponRepository repository;

  RemoveCouponUseCase(this.repository);

  Future<Coupon> call() async {
    return await repository.removeCoupon();
  }
}