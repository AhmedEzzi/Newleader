import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/enums/loading_state.dart';
import '../../../../../core/utils/product cards/custom_gridview_prodcut.dart';
import '../../../../../core/utils/widgets/custom_loading.dart';
import '../../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/product cards/custom_product_card_for_all_products.dart';
import '../controller/search_provider.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';

class SearchResultsGrid extends StatelessWidget {
  final String searchQuery;
  final bool isLoading;
  final ScrollController? scrollController;

  const SearchResultsGrid({
    super.key,
    required this.searchQuery,
    this.isLoading = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {

        if (searchProvider.filteredProductsState == LoadingState.loading &&
            searchProvider.filteredProducts.isEmpty) {
          return const Center(child: CustomLoadingWidget());
        }

        if (searchProvider.filteredProductsState == LoadingState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${'load_products_failed'.tr(context)}: ${searchProvider.errorMessage}',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => searchProvider.fetchFilteredProducts(
                        refresh: true,
                        name: searchQuery,
                      ),
                  child: Text('retry'.tr(context)),
                ),
              ],
            ),
          );
        }

        if (searchProvider.filteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'no_matching_products'.tr(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        final filteredProducts = searchProvider.filteredProducts.where((product) => product.published == 1).toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 8),
                  Text('search_products'.tr(context),style: context.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        searchProvider.hasMoreFilteredProducts &&
                        searchProvider.filteredProductsState != LoadingState.loading) {
                      searchProvider.fetchFilteredProducts(name: searchQuery);
                    }
                    return true;
                  },
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return CustomProductCardForAllProducts(product: product);
                    },
                  ),
                ),
              ),
              // Show loading text at bottom when loading more products
              if (searchProvider.filteredProductsState == LoadingState.loading && 
                  searchProvider.filteredProducts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'loading_more_products'.tr(context),
                    style: context.titleSmall?.copyWith(color: AppTheme.accentColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
