import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/product%20cards/custom_product_card.dart';
import 'package:provider/provider.dart';
import 'package:leader_company/core/utils/widgets/see_all_widget.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/enums/products_type.dart';
import 'package:leader_company/features/presentation/home/controller/home_provider.dart';
import 'package:leader_company/features/presentation/home/widgets/shimmer/all_products_shimmer.dart';

import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/product cards/custom_gridview_prodcut.dart';

class AllProductsWidget extends StatelessWidget {
  const AllProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Show shimmer while loading
        if (homeProvider.allProductsState == LoadingState.loading) {
          return const AllProductsShimmer();
        }

        // Show error state
        if (homeProvider.allProductsState == LoadingState.error) {
          return _buildEmptyState(
            context,
            "Couldn't load products: ${homeProvider.allProductsError}".tr(
              context,
            ),
          );
        }

        // Get products data
        final allProducts = homeProvider.allProducts;

        // Show empty state if no products
        if (allProducts.isEmpty) {
          return _buildEmptyState(context, "no_products_available".tr(context));
        }

        // Filter only published products
        final filteredProducts = allProducts.where((product) => product.published == 1).toList();

        // Show empty state if no published products
        if (filteredProducts.isEmpty) {
          // If we have more pages, trigger fetching more data
          if (homeProvider.hasMoreAllProducts) {
            // Use a future to avoid build during build error
            Future.microtask(() => homeProvider.fetchAllProducts());
            return const AllProductsShimmer();
          }
          return _buildEmptyState(context, "no_products_available".tr(context));
        }

        // Show products grid
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SeeAllWidget(
              title: 'all_products'.tr(context),
              onTap: () {
                AppRoutes.navigateTo(
                  context,
                  AppRoutes.allProductsByTypeScreen,
                  arguments: {
                    'productType': ProductType.all,
                    'title': 'all_products'.tr(context),
                  },
                );
              },
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: filteredProducts.length > 8 ? 8 : filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product,isOutlinedAddToCart: true);
              },
            ),
            // If we have less than 8 published products and more data available, load more
            if (filteredProducts.length < 8 && homeProvider.hasMoreAllProducts)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => homeProvider.fetchAllProducts(),
                    child: Text('load_more'.tr(context)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return const SizedBox.shrink();
  }
}