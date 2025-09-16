import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import '../../../domain/coupon/entities/coupon.dart';
import '../../../../core/utils/widgets/outline_border_button.dart';

class AppliedCouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onRemove;

  const AppliedCouponCard({
    Key? key,
    required this.coupon,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    coupon.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (coupon.couponCode != null) ...[
              const SizedBox(height: 8),
              Text(
                '${'code'.tr(context)}: ${coupon.couponCode}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],

            if (coupon.discountAmount != null) ...[
              const SizedBox(height: 4),
              Text(
                '${'discount'.tr(context)}: ${coupon.discountAmount}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],

            const SizedBox(height: 12),

            CustomOutlinedButton(
              borderColor: Colors.red,
              textColor: Colors.red,
              onPressed: onRemove,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.delete_outline, size: 18),
                  const SizedBox(width: 8),
                  Text('remove_coupon'.tr(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}