import 'package:flutter/material.dart';
import '../../../domain/coupon/entities/coupon.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/coupon/usecases/apply_coupon_usecases.dart';
import '../../../domain/coupon/usecases/remove_coupon_usecases.dart';

class CouponProvider extends ChangeNotifier {
  final ApplyCouponUseCase applyCouponUseCase;
  final RemoveCouponUseCase removeCouponUseCase;

  CouponProvider({
    required this.applyCouponUseCase,
    required this.removeCouponUseCase,
  });

  LoadingState couponState = LoadingState.loading;
  Coupon? appliedCoupon;
  String couponError = '';

  Future<void> applyCoupon(String couponCode) async {
    try {
      couponState = LoadingState.loading;
      notifyListeners();

      appliedCoupon = await applyCouponUseCase(couponCode);
      couponState = LoadingState.loaded;
    } catch (e) {
      couponState = LoadingState.error;
      couponError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> removeCoupon() async {
    try {
      couponState = LoadingState.loading;
      notifyListeners();

      appliedCoupon = await removeCouponUseCase();
      if (appliedCoupon?.success == true) {
        appliedCoupon = null; // Clear coupon if successfully removed
      }
      couponState = LoadingState.loaded;
    } catch (e) {
      couponState = LoadingState.error;
      couponError = e.toString();
    } finally {
      notifyListeners();
    }
  }
}