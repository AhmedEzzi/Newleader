import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/presentation/cart/controller/cart_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/widgets/custom_cached_image.dart';
import '../../../domain/cart/entities/cart.dart';

class ProductItemInCart extends StatelessWidget {
  final CartItem item;
  final int index;
  final Function(int) onDelete;
  final bool isFavorite;
  final Function(int)? onQuantityChanged;

  const ProductItemInCart({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
    this.isFavorite = false,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final bool isUpdating = cartProvider.isItemQuantityUpdating(item.id);
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImage(
                      imageUrl: item.thumbnailImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        item.productName,
                        style: context.titleLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Variant
                      if (item.variant.isNotEmpty)
                        Text(
                          item.variant,
                          style: context.titleSmall.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Price
                      Text(
                        '${item.currencySymbol}${(double.parse(item.discountedPrice) * item.quantity).toStringAsFixed(2)}',
                        style: context.headlineMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Quantity Controls Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity Controls
                          Row(
                            children: [
                              _buildQuantityButton(
                                icon: Icons.remove,
                                onPressed: () {
                                  if (item.quantity > item.lowerLimit && onQuantityChanged != null && !isUpdating) {
                                    onQuantityChanged!(item.quantity - 1);
                                  }
                                },
                                enabled: item.quantity > item.lowerLimit && !cartProvider.isSpecificOperationUpdating(item.id, true) && !cartProvider.isSpecificOperationUpdating(item.id, false),
                                context: context,
                                isUpdating: cartProvider.isSpecificOperationUpdating(item.id, true),
                                isDecrement: true,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}',
                                    style: context.headlineSmall.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              _buildQuantityButton(
                                icon: Icons.add,
                                onPressed: () {
                                  if (item.quantity < item.upperLimit && onQuantityChanged != null && !isUpdating) {
                                    onQuantityChanged!(item.quantity + 1);
                                  }
                                },
                                enabled: item.quantity < item.upperLimit && !cartProvider.isSpecificOperationUpdating(item.id, true) && !cartProvider.isSpecificOperationUpdating(item.id, false),
                                context: context,
                                isUpdating: cartProvider.isSpecificOperationUpdating(item.id, false),
                                isDecrement: false,
                              ),
                            ],
                          ),

                          // Delete Button
                          InkWell(
                            onTap: cartProvider.isItemQuantityUpdating(item.id) ? null : () {
                              onDelete(item.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required BuildContext context,
    required bool isUpdating,
    required bool isDecrement,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: isUpdating
          ? Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor,
              ),
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CustomLoadingWidget(
                    width: 16,
                    height: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDecrement?Colors.transparent:AppTheme.primaryColor,
                border: Border.all(width: 1,color: AppTheme.primaryColor)
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDecrement?AppTheme.primaryColor:AppTheme.white,
              ),
            ),
    );
  }
}