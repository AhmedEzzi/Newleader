import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/helpers.dart';
import 'package:leader_company/core/utils/deep_link_helper.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/presentation/product%20details/controller/product_provider.dart';
import 'package:leader_company/features/presentation/product%20details/widgets/choice_options_widget.dart';
import 'package:leader_company/features/presentation/product%20details/widgets/reviews_section.dart';
import 'package:leader_company/features/presentation/product%20details/widgets/specifications_widget.dart';
import 'package:leader_company/features/presentation/home/controller/home_provider.dart';
import 'package:leader_company/features/presentation/review/controller/reviews_provider.dart';
import 'package:provider/provider.dart';
import '../../wishlist/controller/wishlist_provider.dart';
import '../widgets/color_variants_widget.dart';
import '../widgets/description_widget.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/product_theme.dart';
import '../widgets/quantity_selector_widget.dart';
import '../widgets/related_products_widget.dart';
import '../widgets/shimmers/shimmer_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductDetailsProvider>(
        context,
        listen: false,
      );
      productProvider.fetchProductDetails(widget.slug).then((_) {
        if (productProvider.selectedProduct != null) {
          final homeProvider = Provider.of<HomeProvider>(
            context,
            listen: false,
          );
          homeProvider.fetchRelatedProducts(
            productProvider.selectedProduct!.id,
          );

          final reviewProvider = Provider.of<ReviewProvider>(
            context,
            listen: false,
          );
          reviewProvider.fetchReviews(productProvider.selectedProduct!.id);
        }
      });
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Toggle app bar visibility based on scroll position
    if (_scrollController.offset > 300 && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
    } else if (_scrollController.offset <= 300 && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final initialImageHeight = screenHeight * 0.5;

    return Consumer2<ProductDetailsProvider, HomeProvider>(
      builder: (context, productProvider, homeProvider, child) {
        if (productProvider.productDetailsState == LoadingState.loading) {
          return const ShimmerProductScreen();
        }

        if (productProvider.productDetailsState == LoadingState.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${productProvider.productDetailsError}',
                    style: const TextStyle(color: ProductTheme.errorColor),
                  ),
                  CustomButton(
                    onPressed:
                        () => productProvider.fetchProductDetails(widget.slug),
                    child: Text(
                      'retry'.tr(context),
                      style: context.titleMedium.copyWith(
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (productProvider.selectedProduct == null) {
          return Scaffold(
            body: Center(
              child: Text('no_product_details_data_available'.tr(context)),
            ),
          );
        }

        final product = productProvider.selectedProduct!;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: initialImageHeight,
                    pinned: true,
                    floating: false,
                    snap: false,
                    stretch: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    collapsedHeight: kToolbarHeight,
                    backgroundColor: AppTheme.white,
                    leading:
                        _showAppBar
                            ? const CustomBackButton(respectDirection: true)
                            : const SizedBox.shrink(),
                    title:
                        _showAppBar
                            ? Text(
                              product.name,
                              style: context.titleLarge.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                            : null,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      stretchModes: const [StretchMode.zoomBackground],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ProductImageWidget(
                            product: product,
                            height: double.infinity,
                          ),
                          !_showAppBar
                              ? Positioned(
                                top: statusBarHeight + 16,
                                left:
                                    Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? null
                                        : 16,
                                right:
                                    Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? 16
                                        : null,
                                child: Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.lightDividerColor
                                        .withValues(alpha: 0.6),
                                  ),
                                  child: const CustomBackButton(
                                    respectDirection: true,
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInLeft(
                              duration: const Duration(milliseconds: 700),
                              child: Text(
                                product.name,
                                style: context.headlineMedium.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Add pricing and ratings UI
                            FadeInLeft(
                              duration: const Duration(milliseconds: 700),
                              delay: const Duration(milliseconds: 200),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Rating and review count
                                  Row(
                                    children: [
                                      // Star rating
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < product.rating.floor()
                                                ? Icons.star
                                                : index < product.rating
                                                ? Icons.star_half
                                                : Icons.star_border,
                                            color: AppTheme.primaryColor,
                                            size: 18,
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "(${product.ratingCount} ${'reviews'.tr(context)})",
                                        style: context.bodyMedium.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Price display and fav icon
                            FadeInLeft(
                              duration: const Duration(milliseconds: 700),
                              delay: const Duration(milliseconds: 400),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: product.price,
                                          style: context.headlineMedium
                                              .copyWith(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // IconButton(onPressed: onPressed, icon: icon)
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          final product =
                                              productProvider.selectedProduct;
                                          final linkToShare =
                                              DeepLinkHelper.generateProductShareLink(
                                                widget.slug,
                                                existingLink: product?.link,
                                              );

                                          Share.shareUri(
                                            Uri.parse(linkToShare),
                                          );
                                        },
                                        child: Image.asset(
                                          AppImages.share,
                                          color: AppTheme.primaryColor,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),

                                      Consumer<WishlistProvider>(
                                        builder: (
                                          context,
                                          wishlistProvider,
                                          child,
                                        ) {
                                          return ZoomIn(
                                            duration: const Duration(
                                              milliseconds: 700,
                                            ),
                                            delay: const Duration(
                                              milliseconds: 600,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                wishlistProvider
                                                        .isProductInWishlist(
                                                          widget.slug,
                                                        )
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: AppTheme.primaryColor,
                                                size: 32,
                                              ),
                                              onPressed: () async {
                                                await AppFunctions.toggleWishlistStatus(
                                                  context,
                                                  widget.slug,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Display variations
                            if (product.hasVariation) ...[
                              // Color variants
                              if (product.colors.isNotEmpty) ...[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 700),
                                  delay: const Duration(milliseconds: 500),
                                  child: ColorVariantsWidget(product: product),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Choice options
                              if (product.choiceOptions.isNotEmpty) ...[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 700),
                                  delay: const Duration(milliseconds: 600),
                                  child: ChoiceOptionsWidget(product: product),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],

                            FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              delay: const Duration(milliseconds: 700),
                              child: DescriptionWidget(product: product),
                            ),

                            // Add specifications table widget
                            FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              delay: const Duration(milliseconds: 800),
                              child: SpecificationsWidget(product: product),
                            ),
                          ],
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 900),
                        child: ReviewsSectionWidget(productId: product.id),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 1000),
                        child: RelatedProductsWidget(provider: homeProvider),
                      ),
                      const SizedBox(height: 130),
                    ]),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child:
                    productProvider.isAddingToCart
                        ? const CustomLoadingWidget()
                        : FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ProductTheme.backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                QuantitySelectorWidget(product: product),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: CustomButton(
                                    onPressed:
                                        productProvider.isAddingToCart ||
                                                !productProvider.canAddToCart
                                            ? null
                                            : () {
                                              // For products with variations
                                              if (product.hasVariation) {
                                                final colorVariant =
                                                    productProvider
                                                        .selectedColor ??
                                                    '';
                                                final choiceVariants =
                                                    productProvider
                                                        .variantPrice
                                                        ?.data
                                                        .variant ??
                                                    '';

                                                AppFunctions.addProductToCart(
                                                  context: context,
                                                  productSlug: product.slug,
                                                  productId: product.id,
                                                  productName: product.name,
                                                  variant: choiceVariants,
                                                  quantity:
                                                      productProvider.quantity,
                                                  color: colorVariant,
                                                  hasVariation: false,
                                                );
                                              } else {
                                                AppFunctions.addProductToCart(
                                                  context: context,
                                                  productSlug: product.slug,
                                                  productId: product.id,
                                                  productName: product.name,
                                                  variant: "",
                                                  // No variant for non-variation products
                                                  quantity:
                                                      productProvider.quantity,
                                                  color: "",
                                                  // No color for non-variation products
                                                  hasVariation: false,
                                                );
                                              }
                                            },
                                    child: Center(
                                      child: Text(
                                        productProvider.canAddToCart
                                            ? 'add_to_cart'.tr(context)
                                            : 'out_of_stock'.tr(context),
                                        style: context.headlineSmall.copyWith(
                                          color: AppTheme.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
