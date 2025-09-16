import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/product cards/custom_gridview_prodcut.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/domain/product/entities/product.dart';
import 'package:leader_company/features/presentation/all%20products/widgets/shimmer/products_grid_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/product cards/custom_product_card_for_all_products.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final LoadingState state;
  final String error;
  final bool isLoading;
  final ScrollController scrollController;
  final VoidCallback onRetry;

  const ProductsGrid({
    super.key,
    required this.products,
    required this.state,
    required this.error,
    required this.isLoading,
    required this.scrollController,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Show shimmer when in initial loading state with no products
    if (state == LoadingState.loading && products.isEmpty) {
      return const ProductsGridShimmer();
    }

    if (state == LoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'.tr(context)),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('retry'.tr(context)),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          'no_products_found'.tr(context),
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length + (isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        // Show shimmer for loading items at the bottom instead of CustomLoadingWidget
        if (index >= products.length) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        final product = products[index];
        return CustomProductCardForAllProducts(product: product);
      },
    );
  }
}