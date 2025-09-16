import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/enums/products_type.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/helpers.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/core/utils/widgets/custom_empty_widgets.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/domain/product/entities/product.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../../home/controller/home_provider.dart';
import '../../wishlist/controller/wishlist_provider.dart';
import '../widgets/shimmer/products_grid_shimmer.dart';

class AllProductsByTypeScreen extends StatefulWidget {
  final ProductType productType;
  final String title;
  final int? dealId;

  const AllProductsByTypeScreen({
    super.key,
    required this.productType,
    required this.title,
    this.dealId,
  });

  @override
  _AllProductsByTypeScreenState createState() => _AllProductsByTypeScreenState();
}

class _AllProductsByTypeScreenState extends State<AllProductsByTypeScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  ProductType _selectedProductType = ProductType.all;

  final Map<ProductType, String> _productTypeNames = {
    ProductType.all: 'all_products',
    ProductType.bestSelling: 'best_selling_products',
    ProductType.featured: 'feature_products',
    ProductType.newArrival: 'new_arrival_products',
    ProductType.flashDeal: 'today_deals',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _selectedProductType = widget.productType;
    
    print("PAGINATION_DEBUG: Initializing screen with product type: ${_productTypeNames[_selectedProductType]}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      print("PAGINATION_DEBUG: Initial fetch for ${_productTypeNames[_selectedProductType]}");
      setState(() => _isLoading = true);
      _fetchProducts(homeProvider, refresh: true).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading && 
        _scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.7) {
      print("PAGINATION_DEBUG: Scroll threshold reached (70%), loading more products");
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    
    if (_isLoading) {
      print("PAGINATION_DEBUG: Already loading, skipping request");
      return;
    }
    
    if (!_hasMoreProducts(provider)) {
      print("PAGINATION_DEBUG: No more products to load for ${_productTypeNames[_selectedProductType]}");
      return;
    }
    
    print("PAGINATION_DEBUG: Loading more ${_productTypeNames[_selectedProductType]} products");
    
    // Set loading state and rebuild UI immediately
    setState(() => _isLoading = true);
    
    // Use a microtask to ensure the UI updates before the potentially heavy operation
    await Future.microtask(() => null);
    
    try {
      await _fetchProducts(provider, refresh: false);
      print("PAGINATION_DEBUG: Successfully loaded more products");
    } catch (e) {
      print("PAGINATION_DEBUG: Error loading more products: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchProducts(
    HomeProvider provider, {
    bool refresh = false,
  }) async {
    print("PAGINATION_DEBUG: Fetching products for ${_productTypeNames[_selectedProductType]}, refresh: $refresh");
    
    try {
      switch (_selectedProductType) {
        case ProductType.all:
          await provider.fetchAllProducts(refresh: refresh);
          break;
        case ProductType.bestSelling:
          await provider.fetchBestSellingProducts(refresh: refresh);
          break;
        case ProductType.featured:
          await provider.fetchFeaturedProducts(refresh: refresh);
          break;
        case ProductType.newArrival:
          await provider.fetchNewProducts(refresh: refresh);
          break;
        case ProductType.flashDeal:
          await provider.fetchFlashDealProducts(refresh: refresh);
          break;
      }
      
      // Check if we still have more products after this fetch
      if (mounted) {
        print("PAGINATION_DEBUG: After fetching, hasMoreProducts: ${_hasMoreProducts(provider)}");
        
        // Check if we have enough published products for all product types
        List<Product> products = _getProducts(provider);
        List<Product> publishedProducts = products.where((product) => product.published == 1).toList();
        
        print("PAGINATION_DEBUG: Total products: ${products.length}, Published products: ${publishedProducts.length}");
        
        // If we have very few published products but there are more pages, automatically load more
        if (publishedProducts.length < 4 && _hasMoreProducts(provider)) {
          print("PAGINATION_DEBUG: Not enough published products, loading more automatically");
          // Add a small delay to avoid UI freezes
          await Future.delayed(const Duration(milliseconds: 300));
          await _fetchProducts(provider, refresh: false);
        }
      }
    } catch (e) {
      print("PAGINATION_DEBUG: Error fetching products: $e");
    }
  }

  bool _hasMoreProducts(HomeProvider provider) {
    bool hasMore = false;
    
    switch (_selectedProductType) {
      case ProductType.all:
        hasMore = provider.hasMoreAllProducts;
        break;
      case ProductType.bestSelling:
        hasMore = provider.hasMoreBestSellingProducts;
        break;
      case ProductType.featured:
        hasMore = provider.hasMoreFeaturedProducts;
        break;
      case ProductType.newArrival:
        hasMore = provider.hasMoreNewProducts;
        break;
      case ProductType.flashDeal:
        hasMore = false; // No pagination for flash deal
        break;
    }
    
    print("PAGINATION_DEBUG: hasMoreProducts for ${_productTypeNames[_selectedProductType]}: $hasMore");
    return hasMore;
  }

  List<Product> _getProducts(HomeProvider provider) {
    switch (_selectedProductType) {
      case ProductType.all:
        return provider.allProducts;
      case ProductType.bestSelling:
        return provider.bestSellingProducts;
      case ProductType.featured:
        return provider.featuredProducts;
      case ProductType.newArrival:
        return provider.newProducts;
      case ProductType.flashDeal:
        return provider.flashDealProducts;
    }
  }

  LoadingState _getLoadingState(HomeProvider provider) {
    switch (_selectedProductType) {
      case ProductType.all:
        return provider.allProductsState;
      case ProductType.bestSelling:
        return provider.bestSellingProductsState;
      case ProductType.featured:
        return provider.featuredProductsState;
      case ProductType.newArrival:
        return provider.newProductsState;
      case ProductType.flashDeal:
        return provider.flashDealProductsState;
    }
  }

  String _getErrorMessage(HomeProvider provider) {
    switch (_selectedProductType) {
      case ProductType.all:
        return provider.allProductsError;
      case ProductType.bestSelling:
        return provider.bestSellingProductsError;
      case ProductType.featured:
        return provider.featuredProductsError;
      case ProductType.newArrival:
        return provider.newProductsError;
      case ProductType.flashDeal:
        return provider.flashDealProductsError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final products = _getProducts(homeProvider);
        final state = _getLoadingState(homeProvider);
        final error = _getErrorMessage(homeProvider);
        
        return Scaffold(
          backgroundColor: AppTheme.lightBackgroundColor,
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              
              // Category tabs
              _buildCategoryTabs(homeProvider),
              
              // Products grid
              Expanded(
                child: FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: _buildProductsGrid(
                    products,
                    state,
                    error,
                    homeProvider,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.0,
      title: Text(
        'app_title'.tr(context),
        style: context.displaySmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppTheme.black,
        ),
      ),
      centerTitle: true,
      leading: CustomBackButton(
        respectDirection: isRTL,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppTheme.lightBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.search, color: AppTheme.primaryColor, size: 24),
            onPressed: () {
              AppRoutes.navigateTo(context, AppRoutes.searchScreen);
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }


  Widget _buildCategoryTabs(HomeProvider homeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _buildCategoryTab('all'.tr(context), ProductType.all, Icons.grid_view_rounded),
              _buildCategoryTab('best_sellers'.tr(context), ProductType.bestSelling, Icons.trending_up),
              _buildCategoryTab('new_arrivals'.tr(context), ProductType.newArrival, Icons.new_releases),
              _buildCategoryTab('featured'.tr(context), ProductType.featured, Icons.star_rounded),
              _buildCategoryTab('deals'.tr(context), ProductType.flashDeal, Icons.local_fire_department),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoryTab(String title, ProductType type, IconData icon) {
    final bool isSelected = _selectedProductType == type;
    
    return GestureDetector(
      onTap: () {
        if (_selectedProductType != type) {
          print("PAGINATION_DEBUG: Switching tab from ${_productTypeNames[_selectedProductType]} to ${_productTypeNames[type]}");
          setState(() {
            _selectedProductType = type;
            _isLoading = false;
          });
          
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
          
          _fetchProducts(Provider.of<HomeProvider>(context, listen: false), refresh: true);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected 
            ? LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          color: isSelected ? null : AppTheme.lightBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppTheme.darkDividerColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: context.titleSmall!.copyWith(
                color: isSelected ? Colors.white : AppTheme.darkDividerColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(
    List<Product> products,
    LoadingState state,
    String error,
    HomeProvider homeProvider,
  ) {
    print("PAGINATION_DEBUG: Building grid - LoadingState: $state, Products count: ${products.length}, isLoading: $_isLoading");
    
    if (state == LoadingState.loading && products.isEmpty) {
      return const Center(child: ProductsGridShimmer());
    }

    if (state == LoadingState.error && products.isEmpty) {
      return Center(
        child: FadeIn(
          duration: const Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: context.titleMedium!.copyWith(
                    color: AppTheme.darkDividerColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () => _fetchProducts(
                    Provider.of<HomeProvider>(context, listen: false),
                    refresh: true,
                  ),
                  child: Text('retry'.tr(context)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    List<Product> filteredProducts = products.where((product) => product.published == 1).toList();
    
    print("PAGINATION_DEBUG: Filtered products count: ${filteredProducts.length}");

    if (filteredProducts.isEmpty && products.isNotEmpty && _hasMoreProducts(homeProvider)) {
      print("PAGINATION_DEBUG: All products were filtered out, trying to load more");
      _loadMoreProducts();
      return const Center(child: ProductsGridShimmer());
    }
    
    if (filteredProducts.isEmpty) {
      return const Center(child: CustomEmptyWidget());
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: MasonryGridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final bool isEven = index % 2 == 0;
                
                return FadeInUp(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  child: _buildProductCard(context, product, isEven),
                );
              },
            ),
          ),
        ),
        if (_isLoading)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const CustomLoadingWidget(),
                const SizedBox(height: 12),
                Text(
                  'loading_more_products'.tr(context),
                  style: context.titleSmall!.copyWith(
                    color: AppTheme.darkDividerColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildProductCard(BuildContext context, Product product, bool isEven) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return InkWell(
      onTap: () {
        AppRoutes.navigateTo(
          context,
          AppRoutes.productDetailScreen,
          arguments: {'slug': product.slug},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CustomImage(
                    imageUrl: product.thumbnailImage,
                    height: isEven ? 180 : 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: isRTL ? null : 12,
                  left: isRTL ? 12 : null,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, _) {
                      final isInWishlist = wishlistProvider.isProductInWishlist(product.slug);
                      return GestureDetector(
                        onTap: () {
                          AppFunctions.toggleWishlistStatus(context, product.slug);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isInWishlist ? AppTheme.primaryColor : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            color: isInWishlist ? Colors.white : AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 12,
                    left: isRTL ? null : 12,
                    right: isRTL ? 12 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'sale'.tr(context),
                        style: context.titleSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Product details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: context.titleMedium!.copyWith(
                      color: AppTheme.black,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Text(
                        product.discountedPrice,
                        style: context.titleLarge!.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          product.mainPrice,
                          style: context.titleMedium!.copyWith(
                            color: AppTheme.darkDividerColor,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppTheme.darkDividerColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
