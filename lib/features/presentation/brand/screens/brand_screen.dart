import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_appBar.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../controller/brand_provider.dart';
import '../widgets/brand_grid.dart';
import '../widgets/brand_search.dart';
import '../widgets/shimmer/brand_grid_shimmer.dart';
import '../widgets/shimmer/brand_search_shimmer.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);

    // Initial load
    Future.microtask(() => brandProvider.fetchBrands());

    // Setup scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        brandProvider.fetchBrands(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'brands'.tr(context),
        leading: const CustomBackButton(),
        toolbarHeight: 56.0,
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<BrandProvider>(context, listen: false)
            .fetchBrands(),
        child: Consumer<BrandProvider>(
          builder: (context, provider, _) {
            final isLoading = provider.brandState == LoadingState.loading &&
                provider.brands.isEmpty;
            final hasError = provider.brandState == LoadingState.error;

            if (hasError) {
              return Center(
                child: Text(
                  'error_loading_brands'.tr(context),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: isLoading
                        ? const BrandSearchShimmer()
                        : BrandSearch(
                      onSearch: (query) {
                        provider.fetchBrands(name: query);
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: isLoading
                      ? const BrandGridShimmer()
                      : BrandGrid(
                    brands: provider.brands,
                    isLoadingMore: provider.brandState == LoadingState.loading &&
                        provider.brands.isNotEmpty,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}