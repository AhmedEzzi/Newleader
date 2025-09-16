import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/features/presentation/product%20details/controller/product_provider.dart';
import 'package:leader_company/features/presentation/product%20details/widgets/product_theme.dart';
import 'package:provider/provider.dart';

class QuantitySelectorWidget extends StatelessWidget {
  final ProductDetails product;

  const QuantitySelectorWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        // Get price based on variant selection or default price
        String displayPrice = product.price;
        bool isLoading = false;

        if (product.hasVariation && provider.variantPriceState == LoadingState.loading) {
          isLoading = true;
        } else if (product.hasVariation && provider.variantPrice != null) {
          displayPrice = provider.variantPrice!.data.price;
        }

        // Clean price string and convert to double
        String cleanedPrice = displayPrice.replaceAll(RegExp(r'[^\d.]'), '');
        double price = double.tryParse(cleanedPrice) ?? 0.0;
        int quantity = provider.quantity;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      provider.setQuantity(quantity - 1);
                    }
                  },
                  icon: const Icon(Icons.remove, size: 20),
                ),
                Text(
                  quantity.toString().padLeft(2, '0'),
                  style: context.headlineSmall
                ),
                IconButton(
                  onPressed: () => provider.setQuantity(quantity + 1),
                  icon: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
            isLoading
                ? const CustomLoadingWidget()
                : Text('${(price * quantity).toStringAsFixed(2)} ${product.currencySymbol  }',
              style: context.headlineSmall!.copyWith(color: AppTheme.primaryColor,fontWeight: FontWeight.w900),
            ),
          ],
        );
      },
    );
  }
}