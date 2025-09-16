import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import '../../../../core/utils/extension/translate_extension.dart';

class CouponSection extends StatelessWidget {
  final TextEditingController couponController;
  final bool hasCoupon;
  final String? appliedCouponCode;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onApply;
  final VoidCallback onRemove;
  final bool isInitialLoading; // Optional: for initial loading state

  const CouponSection({
    super.key,
    required this.couponController,
    required this.hasCoupon,
    this.appliedCouponCode,
    required this.isLoading,
    this.errorMessage,
    required this.onApply,
    required this.onRemove,
    this.isInitialLoading = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'discount_coupon'.tr(context),
            style: context.headlineSmall?.copyWith(color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 12),
          if (isInitialLoading || isLoading)
            _buildShimmerEffect(context)
          else if (hasCoupon)
            _buildAppliedCoupon(context)
          else
            _buildCouponInput(context),
          if (errorMessage != null && !hasCoupon && !isLoading && !isInitialLoading)
            ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: context.bodyMedium?.copyWith(color: AppTheme.errorColor),
              ),
            ],
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 80,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliedCoupon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appliedCouponCode!,
                  style: context.bodyLarge,
                ),
                Text(
                  'coupon_applied'.tr(context),
                  style: context.bodyMedium?.copyWith(color: AppTheme.lightSecondaryTextColor),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CustomLoadingWidget(),
            )
          else
            TextButton(
              onPressed: onRemove,
              child: Text(
                'remove'.tr(context),
                style: context.titleMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCouponInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: couponController,
              decoration: InputDecoration(
                hintText: 'enter_coupon_code'.tr(context),
                hintStyle: context.titleMedium?.copyWith(color: AppTheme.lightSecondaryTextColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onApply(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CustomButton(
          borderRadius: 15,
          onPressed: isLoading ? null : onApply,
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CustomLoadingWidget(),
          )
              : Text(
            'apply'.tr(context),
            style: context.titleMedium?.copyWith(color: AppTheme.white),
          ),
        ),
      ],
    );
  }
}