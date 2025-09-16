import 'package:flutter/material.dart';
import 'package:leader_company/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../data/profile/models/profile_counters_model.dart';

class ProfileCountersWidget extends StatelessWidget {
  final ProfileCountersModel counters;

  const ProfileCountersWidget({
    super.key,
    required this.counters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCounterItem(context, counters.cartItemCount, 'cart_items'.tr(context), Icons.shopping_cart, () {
            AppRoutes.navigateTo(context, AppRoutes.cartScreen);
          }),
          _buildCounterItem(context, counters.wishlistItemCount, 'wishlist'.tr(context), Icons.favorite, () {
            Provider.of<LayoutProvider>(context,listen: false).currentIndex=2;
          }),
          _buildCounterItem(context, counters.orderCount, 'orders'.tr(context), Icons.shopping_bag, () {
            AppRoutes.navigateTo(context, AppRoutes.allOrdersListScreen);
          }),
        ],
      ),
    );
  }

  Widget _buildCounterItem(BuildContext context, int count, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}