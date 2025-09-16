import '../../../domain/coupon/entities/coupon.dart';
import '../../../domain/coupon/repositories/coupon_repository.dart';
import '../datasources/coupon_remote_datasource.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDataSource remoteDataSource;

  CouponRepositoryImpl(this.remoteDataSource);

  @override
  Future<Coupon> applyCoupon(String couponCode) async {
    final model = await remoteDataSource.applyCoupon(couponCode);
    return model.toEntity();
  }

  @override
  Future<Coupon> removeCoupon() async {
    final model = await remoteDataSource.removeCoupon();
    return model.toEntity();
  }
}