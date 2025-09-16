import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:leader_company/core/utils/widgets/see_all_widget.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/enums/products_type.dart';
import 'package:leader_company/features/presentation/home/controller/home_provider.dart';
import 'package:leader_company/features/presentation/home/widgets/shimmer/new_products_shimmer.dart';

import '../../../../core/utils/product cards/custom_gridview_prodcut.dart';
import '../../../../core/utils/product cards/custom_product_card.dart';
import '../../../../core/utils/product cards/custom_product_row.dart';

class NewProductsWidget extends StatelessWidget {
  const NewProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Show shimmer while loading
        if (homeProvider.newProductsState == LoadingState.loading) {
          return const NewProductsShimmer();
        }

        // Show error state
        if (homeProvider.newProductsState == LoadingState.error) {
          return _buildEmptyState(context, "no_products_available".tr(context));
        }

        // Get products data
        final products = homeProvider.newProducts;

        // Show empty state if no products
        if (products.isEmpty) {
          return _buildEmptyState(
            context,
            "no_new_products_available".tr(context),
          );
        }

        // Show products carousel
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SeeAllWidget(
              title: 'new_arrival'.tr(context),
              onTap: () {
                AppRoutes.navigateTo(
                  context,
                  AppRoutes.allProductsByTypeScreen,
                  arguments: {
                    'productType': ProductType.newArrival,
                    'title': 'new_arrival_products'.tr(context),
                  },
                );
              },
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder:
                    (context, index) => ProductCard(product: products[index],isOutlinedAddToCart: true),
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
