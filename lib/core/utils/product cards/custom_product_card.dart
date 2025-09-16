import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';
import '../../../../features/domain/product/entities/product.dart';
import '../../../features/presentation/wishlist/controller/wishlist_provider.dart';
import '../../config/routes.dart/routes.dart';
import '../constants/app_strings.dart';
import '../helpers.dart';
import '../widgets/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import '../../../features/presentation/cart/controller/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool? isOutlinedAddToCart;
  final bool? isBuyNow;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    this.isOutlinedAddToCart = false,
    this.isBuyNow = false,
    this.index = 0,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isAddingToCart = false;
  bool _showWishlistAnimation = false;

  void _triggerWishlistAnimation() {
    if (mounted) {
      setState(() {
        _showWishlistAnimation = true;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _showWishlistAnimation = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 100 + (widget.index * 50)),
      duration: const Duration(milliseconds: 400),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          AppRoutes.navigateTo(
            context,
            AppRoutes.productDetailScreen,
            arguments: {'slug': widget.product.slug},
          );
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: CustomImage(
                          imageUrl: widget.product.thumbnailImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Product details
                    Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        // Rating stars
                        !widget.isBuyNow!
                            ? const SizedBox.shrink()
                            : Row(
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.star_outline_sharp,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ),
                            ),
                        // Product name
                        Text(
                          widget.product.name,
                          style: context.titleLarge.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          textAlign:
                              Directionality.of(context) == TextDirection.rtl
                                  ? TextAlign.right
                                  : TextAlign.left,
                        ),

                        // Price and fav icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.discountedPrice,
                                    style: context.titleLarge.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign:
                                        Directionality.of(context) ==
                                                TextDirection.rtl
                                            ? TextAlign.right
                                            : TextAlign.left,
                                  ),
                                  Text(
                                    widget.product.mainPrice,
                                    style: context.titleMedium.copyWith(
                                      color: AppTheme.lightSecondaryTextColor,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    textAlign:
                                        Directionality.of(context) ==
                                                TextDirection.rtl
                                            ? TextAlign.right
                                            : TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Consumer<WishlistProvider>(
                              builder: (context, provider, _) {
                                final isInWishlist = provider
                                    .isProductInWishlist(widget.product.slug);

                                return LikeButton(
                                  isFavorite: isInWishlist,
                                  iconColor: AppTheme.primaryColor,
                                  onPressed: () async {
                                    (AppStrings.token == null || isInWishlist)
                                        ? null
                                        : _triggerWishlistAnimation();
                                    await AppFunctions.toggleWishlistStatus(
                                      context,
                                      widget.product.slug,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),

                        isAddingToCart
                            ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CustomLoadingWidget()],
                            )
                            : CustomButton(
                          height: 40,
                              text:
                                  widget.product.currentStock < 1
                                      ? 'out_of_stock'.tr(context)
                                      : widget.isBuyNow!
                                      ? 'buy_now'.tr(context)
                                      : 'add_to_cart'.tr(context),
                              textStyle: context.titleLarge.copyWith(
                                color:
                                    widget.isOutlinedAddToCart!
                                        ? AppTheme.primaryColor
                                        : AppTheme.white,
                                fontWeight: FontWeight.w900,
                              ),
                              fullWidth: true,
                              borderRadius: 8,
                              isOutlined: widget.isOutlinedAddToCart!,
                              padding: const EdgeInsets.all(8),
                              onPressed: () async {
                                if(widget.product.currentStock < 1){
                                  return;
                                }
                                setState(() {
                                  isAddingToCart = true;
                                });

                                // Store the current cart count
                                final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                );

                                await AppFunctions.addProductToCart(
                                  context: context,
                                  productId: widget.product.id,
                                  productName: widget.product.name,
                                  productSlug: widget.product.slug,
                                  hasVariation: widget.product.hasVariation,
                                );

                                setState(() {
                                  isAddingToCart = false;
                                });

                                // Only navigate if it's buy now and the product was added successfully
                                if (widget.isBuyNow! &&
                                    cartProvider.lastAddToCartSuccess) {
                                  if (context.mounted) {
                                    // Use the optimized navigation that sets a flag to avoid unnecessary API calls
                                    Provider.of<LayoutProvider>(
                                      context,
                                      listen: false,
                                    ).navigateToCartFromBuyNow();
                                  }
                                }
                              },
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_showWishlistAnimation)
              Opacity(
                opacity: 0.05,
                child: Lottie.asset(
                  AppAnimations.wishlistAnimation,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
