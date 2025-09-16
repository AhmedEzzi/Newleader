import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../../domain/cart/entities/cart.dart';

class CheckoutCartItem extends StatelessWidget {
  final CartItem item;

  const CheckoutCartItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImage(
              imageUrl:  item.thumbnailImage,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                item.variant == '' ? const SizedBox.shrink() : Text('Model: ${item.variant}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.currencySymbol}${item.discountedPrice}',
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Quantity
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Qty: ${item.quantity}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
} 