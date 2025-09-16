
import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../models/coupon_model.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';

abstract class CouponRemoteDataSource {
  Future<CouponModel> applyCoupon(String couponCode);
  Future<CouponModel> removeCoupon();
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  CouponRemoteDataSourceImpl(this.apiProvider, this.secureStorage);



  @override
  Future<CouponModel> applyCoupon(String couponCode) async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.couponApply,
      data: {
        'user_id': AppStrings.userId.toString(),
        'coupon_code': couponCode,
      },
    );
    if (response.data != null) {
      return CouponModel.fromJson(response.data);
    }
    throw Exception('Invalid coupon apply response');
  }

  @override
  Future<CouponModel> removeCoupon() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.couponRemove,
      data: {
        'user_id': AppStrings.userId.toString(),
      },
    );
    if (response.data != null) {
      return CouponModel.fromJson(response.data);
    }
    throw Exception('Invalid coupon remove response');
  }
}