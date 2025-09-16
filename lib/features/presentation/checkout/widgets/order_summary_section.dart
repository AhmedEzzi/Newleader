import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';
import '../../../domain/cart/entities/cart.dart';
import './checkout_cart_item.dart';

class OrderSummarySection extends StatelessWidget {
  final CartSummary cartSummary;
  final List<CartItem> cartItems;
  final bool isUpdatingShipping;
  final String? shippingError;
  final bool isInitialLoading;
  final TextEditingController noteController;

  const OrderSummarySection({
    super.key,
    required this.cartSummary,
    required this.cartItems,
    this.isUpdatingShipping = false,
    this.shippingError,
    this.isInitialLoading = false,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasCoupon =
        !isInitialLoading &&
        cartSummary.couponApplied &&
        cartSummary.couponCode != null &&
        cartSummary.couponCode!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Items List
          if (isInitialLoading)
            _buildItemsShimmer()
          else
            _buildCartItems(),

          const SizedBox(height: 24),
          
          // Price Summary
          _buildPriceSummary(context, hasCoupon),

          const SizedBox(height: 24),
          
          // Add note to order section
          _buildNoteSection(context),
        ],
      ),
    );
  }

  Widget _buildNoteSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Note Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: 0.1),
                  Colors.blue.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.note_outlined,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'order_notes'.tr(context),
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Note Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'add_note_to_order'.tr(context),
                hintStyle: context.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsShimmer() {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 60, height: 60, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 80, height: 14, color: Colors.white),
                    ],
                  ),
                ),
                Container(width: 40, height: 20, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          _buildShimmerPriceRow(),
          const SizedBox(height: 12),
          _buildShimmerPriceRow(),
          const SizedBox(height: 12),
          _buildShimmerPriceRow(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.grey, thickness: 0.5, height: 1),
          ),
          _buildShimmerPriceRow(isTotal: true),
        ],
      ),
    );
  }

  Widget _buildShimmerPriceRow({bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 80, height: isTotal ? 16 : 14, color: Colors.white),
        Container(width: 60, height: isTotal ? 16 : 14, color: Colors.white),
      ],
    );
  }

  Widget _buildCartItems() {
    return Column(
      children: cartItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Column(
          children: [
            CheckoutCartItem(item: item),
            if (index < cartItems.length - 1)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 1,
                color: Colors.grey[200],
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildModernCartItems(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'order_items'.tr(context),
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${cartItems.length} ${cartItems.length == 1 ? 'item'.tr(context) : 'items'.tr(context)}',
                    style: context.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Items List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: cartItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    CheckoutCartItem(item: item),
                    if (index < cartItems.length - 1)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        height: 1,
                        color: Colors.grey[200],
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context, bool hasCoupon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'price_summary'.tr(context),
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          if (isInitialLoading)
            _buildShimmerEffect(context)
          else
            Column(
              children: [
                _buildPriceRow(
                  context: context,
                  label: 'subtotal'.tr(context),
                  value: '${(cartSummary.subtotal)} ${cartSummary.currencySymbol}',
                ),
                const SizedBox(height: 12),
                _buildPriceRow(
                  context: context,
                  label: 'shipping'.tr(context),
                  value:
                      cartSummary.shippingCost > 0
                          ? '${cartSummary.shippingCost.toStringAsFixed(2)} ${cartSummary.currencySymbol}'
                          : 'free_shipping'.tr(context),
                  isLoading: isUpdatingShipping,
                  color: cartSummary.shippingCost > 0 ? AppTheme.primaryColor : AppTheme.successColor,
                ),
                if (hasCoupon)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildPriceRow(
                      context: context,
                      label: 'discount'.tr(context),
                      value:
                          '-${cartSummary.discount.toStringAsFixed(2)} ${cartSummary.currencySymbol}',
                      color: AppTheme.errorColor,
                    ),
                  ),
                const SizedBox(height: 12),
                _buildPriceRow(
                  context: context,
                  label: 'tax'.tr(context),
                  value:
                      '${cartSummary.tax.toStringAsFixed(2)} ${cartSummary.currencySymbol}',
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primaryColor.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.1),
                        AppTheme.primaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildPriceRow(
                    context: context,
                    label: 'total'.tr(context),
                    value:
                        '${cartSummary.total.toStringAsFixed(2)} ${cartSummary.currencySymbol}',
                    valueStyle: context.headlineSmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: context.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required BuildContext context,
    required String label,
    required String value,
    bool isLoading = false,
    Color color = Colors.black,
    TextStyle? valueStyle,
    TextStyle? labelStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: labelStyle ?? context.titleMedium!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isLoading)
          const CustomLoadingWidget()
        else
          Text(
            value, 
            style: valueStyle ?? context.titleMedium!.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
