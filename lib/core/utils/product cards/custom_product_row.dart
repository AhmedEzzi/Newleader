import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../../../../features/domain/product/entities/product.dart';
import '../../../../features/presentation/wishlist/controller/wishlist_provider.dart';
import '../../config/routes.dart/routes.dart';
import '../helpers.dart';
import '../widgets/like_button.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';

class ProductItemInRow1 extends StatefulWidget {
  final Product product;

  const ProductItemInRow1({super.key, required this.product});

  @override
  State<ProductItemInRow1> createState() => _ProductItemInRow1State();
}

class _ProductItemInRow1State extends State<ProductItemInRow1> {
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Row(
              children: [
                // Left section with product details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product name
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price display
                      Text('\$${widget.product.discountedPrice}'.tr(context),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      // Original price (strikethrough) if present
                      if (widget.product.hasDiscount)
                        Text('\$${widget.product.mainPrice}'.tr(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      // Add to cart button
                      GestureDetector(
                        onTap:
                            () =>
                                widget.product.currentStock < 1
                                    ? null
                                    : AppFunctions.addProductToCart(
                                      context: context,
                                      productId: widget.product.id,
                                      productName: widget.product.name,
                                      productSlug: widget.product.slug,
                                      hasVariation: widget.product.hasVariation,
                                    ),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color:
                                widget.product.currentStock < 1
                                    ? Colors.grey
                                    : Colors.blue,
                            borderRadius:
                                Directionality.of(context) == TextDirection.ltr
                                    ? BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    )
                                    : BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right section with product image
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius:
                        Directionality.of(context) == TextDirection.ltr
                            ? const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            )
                            : const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                    child: CustomImage(imageUrl: widget.product.thumbnailImage),
                  ),
                ),
              ],
            ),

            // Favorite icon overlay with Consumer
            Positioned(
              top: 0,
              right: Directionality.of(context) == TextDirection.ltr ? 0 : null,
              left: Directionality.of(context) == TextDirection.rtl ? 0 : null,
              child: Consumer<WishlistProvider>(
                builder: (context, provider, _) {
                  final isFavorite = provider.isProductInWishlist(widget.product.slug);

                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius:
                          Directionality.of(context) == TextDirection.ltr
                              ? const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              )
                              : const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                    ),
                    child: Center(
                      child: LikeButton(
                        isFavorite: isFavorite,
                        iconColor: AppTheme.primaryColor,
                        size: 20,
                        onPressed: () async {
                          bool wasInWishlist = isFavorite;
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
            // Conditionally display Lottie animation
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
      ),
    );
  }
}
