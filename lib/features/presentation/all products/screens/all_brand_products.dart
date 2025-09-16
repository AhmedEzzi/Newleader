import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_empty_widgets.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/features/domain/product/entities/product.dart' as product_import;
import 'package:provider/provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/widgets/custom_cached_image.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/brand/entities/brand.dart';
import '../../home/controller/home_provider.dart';
import '../../wishlist/controller/wishlist_provider.dart';
import '../../brand/controller/brand_provider.dart';
import '../widgets/shimmer/products_grid_shimmer.dart';

class AllBrandProductsScreen extends StatefulWidget {
  final Brand brand;

  const AllBrandProductsScreen({
    super.key,
    required this.brand,
  });

  @override
  State<AllBrandProductsScreen> createState() => _AllBrandProductsScreenState();
}

class _AllBrandProductsScreenState extends State<AllBrandProductsScreen>
    with TickerProviderStateMixin {
  late String _selectedBrandName;
  late String _selectedBrandSlug;
  bool _isLoading = false;
  final ScrollController _mainScrollController = ScrollController();
  bool _showFloatingButton = false;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  
  TabController? _tabController;
  int _selectedBrandIndex = 0;

  @override
  void initState() {
    super.initState();
    _mainScrollController.addListener(_mainScrollListener);
    _selectedBrandName = widget.brand.name;
    _selectedBrandSlug = widget.brand.slug;

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brandProvider = Provider.of<BrandProvider>(context, listen: false);
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      
      // جلب جميع البراندات
      brandProvider.fetchBrands().then((_) {
        // العثور على فهرس البراند المحدد
        final brands = brandProvider.brands;
        _selectedBrandIndex = brands.indexWhere((brand) => brand.slug == widget.brand.slug);
        if (_selectedBrandIndex == -1) _selectedBrandIndex = 0;
        
        // إنشاء TabController
        _tabController = TabController(
          length: brands.length,
          vsync: this,
          initialIndex: _selectedBrandIndex,
        );
        
        _tabController?.addListener(() {
          if (_tabController?.indexIsChanging == true) {
            _onBrandChanged(_tabController?.index ?? 0);
          }
        });
        
        setState(() {});
      });
      
      // جلب منتجات البراند الحالي
      homeProvider.fetchBrandProducts(
        _selectedBrandSlug,
        refresh: true,
      );
    });
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _fabAnimationController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _onBrandChanged(int index) {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    
    if (index < brandProvider.brands.length) {
      final selectedBrand = brandProvider.brands[index];
      setState(() {
        _selectedBrandIndex = index;
        _selectedBrandName = selectedBrand.name;
        _selectedBrandSlug = selectedBrand.slug;
      });
      
      // جلب منتجات البراند الجديد
      homeProvider.fetchBrandProducts(
        _selectedBrandSlug,
        refresh: true,
      );
    }
  }

  void _mainScrollListener() {
    const threshold = 300.0;
    
    if (_mainScrollController.offset > threshold && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
      _fabAnimationController.forward();
    } else if (_mainScrollController.offset <= threshold && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
      _fabAnimationController.reverse();
    }

    if (_mainScrollController.position.pixels >= 
        _mainScrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  void _scrollToTop() {
    _mainScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading) return;
    final provider = Provider.of<HomeProvider>(context, listen: false);

    if (!provider.hasMoreBrandProducts) return;
    setState(() => _isLoading = true);

    try {
      await provider.fetchBrandProducts(_selectedBrandSlug);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _retryLoading() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.fetchBrandProducts(
      _selectedBrandSlug,
      refresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, BrandProvider>(
      builder: (context, homeProvider, brandProvider, child) {
        final products = homeProvider.brandProducts;
        final state = homeProvider.brandProductsState;
        final error = homeProvider.brandProductsError;

        return Scaffold(
          backgroundColor: AppTheme.lightBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildAppBar(context),
                  _buildBrandTabBar(brandProvider),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: _buildProductsGrid(products, state, error),
                  ),
                  if (_isLoading) _buildLoadingIndicator(),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: Opacity(
            opacity: _fabAnimation.value,
            child: FloatingActionButton(
              mini: true,
              onPressed: _scrollToTop,
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              elevation: 8,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FadeIn(
        duration: const Duration(milliseconds: 400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              const CustomBackButton(respectDirection: true),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    _selectedBrandName.toUpperCase(),
                    style: context.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandTabBar(BrandProvider brandProvider) {
    if (brandProvider.brandState == LoadingState.loading) {
      return Container(
        margin: const EdgeInsets.all(16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (brandProvider.brandState == LoadingState.error || brandProvider.brands.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'no_brands_available'.tr(context),
          style: context.titleMedium!.copyWith(
            color: AppTheme.darkDividerColor,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: brandProvider.brands.isNotEmpty && _tabController != null
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 2,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.darkDividerColor,
                labelStyle: context.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: context.titleMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                tabs: brandProvider.brands.map((brand) {
                  return Tab(
                    text: brand.name,
                  );
                }).toList(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildProductsGrid(
    List<product_import.Product> products,
    LoadingState state,
    String error,
  ) {
    if (state == LoadingState.loading && products.isEmpty) {
      return const ProductsGridShimmer();
    }

    if (state == LoadingState.error) {
      return _buildErrorWidget(error);
    }

    if (products.isEmpty) {
      return const Center(child: CustomEmptyWidget());
    }

    final filteredProducts = products.where((product) => product.published == 1).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
    );
  }

  Widget _buildErrorWidget(String error) {
    final errorMessage = error.isNotEmpty ? error : 'error_occurred'.tr(context);
    return Container(
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Container(
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
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: context.titleMedium!.copyWith(
                  color: AppTheme.darkDividerColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _retryLoading,
                child: Text(
                  'retry'.tr(context),
                  style: context.titleLarge!.copyWith(color: AppTheme.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProductCard(BuildContext context, product_import.Product product, bool isEven) {
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
                    mainAxisAlignment: isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Text(
                        product.discountedPrice,
                        style: context.headlineSmall!.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          product.mainPrice,
                          style: context.bodyLarge!.copyWith(
                            color: AppTheme.darkDividerColor,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppTheme.primaryColor,
                            decorationThickness: 4
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

  Widget _buildLoadingIndicator() {
    return Container(
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
    );
  }
} 