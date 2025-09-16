import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/widgets/custom_appBar.dart';
import '../controller/coupon_provider.dart';
import '../widgets/coupon_form.dart';
import '../widgets/applied_coupon_card.dart';
import '../widgets/coupon_error_message.dart';
import '../widgets/shimmer/coupon_form_shimmer.dart';
import '../widgets/shimmer/applied_coupon_card_shimmer.dart';

class CouponScreen extends StatefulWidget {
  final Function(double)? onCouponApplied;

  const CouponScreen({
    super.key,
    this.onCouponApplied,
  });

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'apply_coupon'.tr(context),
        toolbarHeight: kToolbarHeight,
      ),
      body: Consumer<CouponProvider>(
        builder: (context, couponProvider, child) {
          final isLoading = couponProvider.couponState == LoadingState.loading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Coupon input form
                isLoading
                    ? const CouponFormShimmer()
                    : CouponForm(
                  onApplyCoupon: (couponCode) => _applyCoupon(couponCode, couponProvider),
                ),

                const SizedBox(height: 24),

                // Applied coupon section
                if (isLoading && couponProvider.appliedCoupon != null)
                  const AppliedCouponCardShimmer()
                else if (couponProvider.appliedCoupon != null)
                  AppliedCouponCard(
                    coupon: couponProvider.appliedCoupon!,
                    onRemove: () => _removeCoupon(couponProvider),
                  ),

                // Error message
                if (couponProvider.couponState == LoadingState.error)
                  CouponErrorMessage(error: couponProvider.couponError)
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _applyCoupon(String couponCode, CouponProvider couponProvider) async {
    await couponProvider.applyCoupon(couponCode);

    if (!mounted) return;

    if (couponProvider.appliedCoupon?.success == true &&
        couponProvider.appliedCoupon?.discountAmount != null &&
        widget.onCouponApplied != null) {
      widget.onCouponApplied!(couponProvider.appliedCoupon!.discountAmount!);
    }

    if (couponProvider.appliedCoupon?.success == true) {
      _showSuccessMessage(couponProvider.appliedCoupon!.message);
    }
  }

  Future<void> _removeCoupon(CouponProvider couponProvider) async {
    await couponProvider.removeCoupon();

    if (!mounted) return;

    if (couponProvider.appliedCoupon == null && widget.onCouponApplied != null) {
      widget.onCouponApplied!(0); // Reset discount to zero
    }

    _showSuccessMessage('coupon_removed_successfully'.tr(context));
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}