import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:provider/provider.dart';
import 'package:leader_company/core/utils/widgets/see_all_widget.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/enums/products_type.dart';
import 'package:leader_company/features/presentation/home/controller/home_provider.dart';
import 'package:leader_company/features/presentation/home/widgets/shimmer/featured_products_shimmer.dart';
import 'package:leader_company/features/presentation/home/widgets/featured_product_card.dart';

import '../../../../core/utils/product cards/custom_product_card.dart';

class FeaturedProductsWidget extends StatelessWidget {
  const FeaturedProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Show shimmer while loading
        if (homeProvider.featuredProductsState == LoadingState.loading) {
          return const FeaturedProductsShimmer();
        }

        // Show error state
        if (homeProvider.featuredProductsState == LoadingState.error) {
          return _buildEmptyState();
        }

        // Get products data
        final products = homeProvider.featuredProducts;

        // Show empty state if no products
        if (products.isEmpty) {
          return _buildEmptyState();
        }
        final filteredProducts = products.where((product) => product.published.toString() == '1').toList();

        // Show products list
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SeeAllWidget(
                title: 'featured_collection'.tr(context),
                onTap: () {
                  AppRoutes.navigateTo(
                    context,
                    AppRoutes.allProductsByTypeScreen,
                    arguments: {
                      'productType': ProductType.featured,
                      'title': 'featured_collection'.tr(context),
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 330,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) => 
                    FeaturedProductCard(
                      product: filteredProducts[index],
                      width: 250,
                    ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }
}
