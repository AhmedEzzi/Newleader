import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/helpers.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/cutsom_toast.dart';
import 'package:leader_company/features/presentation/wishlist/widgets/shimmer/wishlist_screen_shimmer.dart';
import 'package:leader_company/features/presentation/wishlist/widgets/snappable_wishlist_item.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_cached_image.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../../../domain/wishlist/entities/wishlist_details.dart';
import '../controller/wishlist_provider.dart';
import 'empty_wishlist_widget.dart';

class WishlistWidget extends StatefulWidget {
  final WishlistProvider provider;
  final bool triggerAnimation;

  const WishlistWidget({
    super.key, 
    required this.provider, 
    this.triggerAnimation = true
  });

  @override
  State<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  bool _shouldAnimate = true;

  @override
  void initState() {
    super.initState();
    _shouldAnimate = widget.triggerAnimation;
  }
  
  @override
  void didUpdateWidget(WishlistWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerAnimation != oldWidget.triggerAnimation) {
      setState(() {
        _shouldAnimate = widget.triggerAnimation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If wishlist is empty, return the full-screen empty widget
    if (widget.provider.wishlistState != LoadingState.loading && 
        widget.provider.wishlistItems.isEmpty) {
      return const EmptyWishlistWidget();
    }
    
    // If wishlist has items, show the regular layout with AppBar
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'wishlist'.tr(context),
          style: context.displaySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: widget.provider.wishlistState == LoadingState.loading
          ? const WishlistScreenShimmer()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: widget.provider.wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = widget.provider.wishlistItems[index];
                  if (item.name == "Loading...") {
                    return const SizedBox.shrink();
                  }
                  
                  return _buildProductCard(context, item, index);
                },
              ),
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, WishlistItem wishlistItem, int index) {
    final GlobalKey<SnappableWishlistItemState> snappableKey =
        GlobalKey<SnappableWishlistItemState>();

    return FadeInUp(
      duration: Duration(milliseconds: 600 + (index * 100)),
      delay: Duration(milliseconds: index * 100),
      child: SnappableWishlistItem(
        key: snappableKey,
        slug: wishlistItem.slug,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              InkWell(
                onTap: () => _navigateToProductDetails(context, wishlistItem.slug),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImage(
                      imageUrl: wishlistItem.thumbnailImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
            
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    InkWell(
                      onTap: () => _navigateToProductDetails(context, wishlistItem.slug),
                      child: Text(
                        wishlistItem.name,
                        style: context.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Price
                    Text(
                      wishlistItem.price,
                      style: context.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Rating
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < wishlistItem.rating.floor()
                              ? Icons.star
                              : starIndex < wishlistItem.rating
                                  ? Icons.star_half
                                  : Icons.star_border,
                          color: const Color(0xFFFFB800),
                          size: 18,
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Add to Cart Button
                    CustomButton(
                      onPressed: () => _addToCart(context, wishlistItem),
                      child: Text(
                        'add_to_cart'.tr(context),
                        textAlign: TextAlign.center,
                        style: context.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Wishlist Heart Button
              GestureDetector(
                onTap: () {
                  snappableKey.currentState?.startSnap();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, String slug) {
    AppRoutes.navigateTo(
      context,
      AppRoutes.productDetailScreen,
      arguments: {'slug': slug},
    );
  }
  
  void _addToCart(BuildContext context, wishlistItem) {
    AppFunctions.addProductToCart(
      context: context,
      productId: wishlistItem.productId,
      productName: wishlistItem.name,
      productSlug: wishlistItem.slug,
      hasVariation: wishlistItem.hasVariation,
    );
  }
  
  void _showClearWishlistDialog(BuildContext context) {
    showCustomConfirmationDialog(
      context: context,
      title: 'clear_wishlist'.tr(context),
      message: 'clear_wishlist_confirmation'.tr(context),
      confirmText: 'clear'.tr(context),
      cancelText: 'cancel'.tr(context),
      icon: Icons.delete_outline,
      confirmButtonColor: AppTheme.accentColor,
      onConfirm: () {
        widget.provider.clearWishlist();
        CustomToast.showToast(message: 'wishlist_cleared'.tr(context), type: ToastType.success);
      },
    );
  }
}
