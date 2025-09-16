import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/responsive_extension.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:provider/provider.dart';
import '../../../../features/domain/product/entities/product.dart';
import '../../../../features/presentation/wishlist/controller/wishlist_provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../helpers.dart';
import '../widgets/custom_cached_image.dart';
import '../widgets/like_button.dart';
import 'package:lottie/lottie.dart';

class ProductGridCard extends StatefulWidget {
  final Product product;
  final bool availableAddToCart;

  const ProductGridCard({
    super.key,
    required this.product,
    this.availableAddToCart = false,
  });

  @override
  State<ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<ProductGridCard> {
  bool _showWishlistAnimation = false;

  void _triggerWishlistAnimation() {
    if (mounted) {
      setState(() {
        _showWishlistAnimation = true;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
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
    return InkWell(
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
          Container(
            width: context.responsive(160),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomImage(
                            width: double.infinity,
                            imageUrl: widget.product.thumbnailImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Product details
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
                            Text(
                              widget.product.name,
                              style: context.titleSmall!.copyWith(fontWeight: FontWeight.w600,color: AppTheme.black),
                              maxLines: 1,
                              textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                            ),
                            const SizedBox(height: 6),
                            // Price
                            Text(widget.product.discountedPrice, 
                                 style: context.titleSmall!.copyWith(fontWeight: FontWeight.w600,color: AppTheme.primaryColor),
                                 textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right:
                    Directionality.of(context) == TextDirection.ltr ? 0 : null,
                    left:
                    Directionality.of(context) == TextDirection.rtl ? 0 : null,
                    child: Consumer<WishlistProvider>(
                      builder: (context, provider, _) {
                        final isInWishlist = provider.isProductInWishlist(
                          widget.product.slug,
                        );

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: LikeButton(
                              isFavorite: isInWishlist,
                              iconColor: AppTheme.primaryColor,
                              size: 22,
                              onPressed: () async {
                                bool wasInWishlist = isInWishlist;
                                await AppFunctions.toggleWishlistStatus(
                                  context,
                                  widget.product.slug,
                                );
                                final nowInWishlist = Provider.of<WishlistProvider>(context, listen: false)
                                    .isProductInWishlist(widget.product.slug);
                                if (!wasInWishlist && nowInWishlist) {
                                  _triggerWishlistAnimation();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: widget.availableAddToCart ? 0 : 2,
                    right:
                        Directionality.of(context) == TextDirection.ltr
                            ? (widget.availableAddToCart ? 0 : 2)
                            : null,
                    left:
                        Directionality.of(context) == TextDirection.rtl
                            ? (widget.availableAddToCart ? 0 : 2)
                            : null,
                    child: InkWell(
                      onTap: () {
                        widget.availableAddToCart
                            ? widget.product.currentStock < 1
                                ? null
                                : AppFunctions.addProductToCart(
                                  context: context,
                                  productId: widget.product.id,
                                  productName: widget.product.name,
                                  productSlug: widget.product.slug,
                                  hasVariation: widget.product.hasVariation,
                                )
                            : null;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              !widget.availableAddToCart
                                  ? AppTheme.accentColor.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:
                            !widget.availableAddToCart
                                ? Text(
                                  'new'.tr(context),
                                  style: context.bodySmall?.copyWith(
                                    color:
                                        !widget.availableAddToCart
                                            ? AppTheme.accentColor
                                            : AppTheme.primaryColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )
                                : const CustomImage(assetPath: AppSvgs.active_cart_icon),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showWishlistAnimation)
            Center(
              child: Lottie.asset(
                AppAnimations.wishlistAnimation,
                width: 180,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
