import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/features/presentation/search/widgets/shimmer/popular_searches_shimmer.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/product cards/custom_gridview_prodcut.dart';
import '../../../../core/utils/product cards/custom_product_card_for_all_products.dart';
import '../../../domain/product/entities/product.dart';
import '../controller/search_provider.dart';

class PopularSearches extends StatelessWidget {
  final bool isLoading;
  final List<Product> popularProducts; // Example terms, replace with actual data

  const PopularSearches({super.key, this.isLoading = false, required this.popularProducts});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = popularProducts.where((product) => product.published == 1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'most_searched'.tr(context),
            style: context.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              if (index >= filteredProducts.length) {
                return const Center(child: PopularSearchesShimmer());
              }

              final product = filteredProducts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomProductCardForAllProducts(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}