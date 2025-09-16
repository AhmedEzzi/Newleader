import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:leader_company/features/domain/cart/entities/cart.dart';
import 'package:leader_company/features/presentation/cart/widgets/snappable_cart_item.dart';
import 'package:leader_company/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../coupon/controller/coupon_provider.dart';
import '../controller/cart_provider.dart';
import '../widgets/empty_cart_widget.dart';
import '../widgets/shimmer/cart_screen_shimmer.dart';

class CartScreen extends StatefulWidget {
  final bool skipDataRefresh;
  final bool isActive;
  
  const CartScreen({
    super.key, 
    this.skipDataRefresh = false,
    this.isActive = false
  });

  /// Factory constructor for direct navigation from Buy Now
  /// that uses the existing cart data to minimize API calls
  static Widget forBuyNow(BuildContext context) {
    // Get the cart provider and check if we already have cart data
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // If we already have cart items, skip the reload
    final skipDataRefresh = cartProvider.cartItems.isNotEmpty;
    
    return CartScreen(skipDataRefresh: skipDataRefresh);
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isApplyingCoupon = false;
  bool _shouldAnimate = false;
  final Set<int> _itemsBeingDeleted = {};

  @override
  void initState() {
    super.initState();
    _shouldAnimate = widget.isActive;
    
    // Check if we should skip data loading (either through the direct prop or from LayoutProvider)
    final layoutProvider = Provider.of<LayoutProvider>(context, listen: false);
    final shouldSkipRefresh = widget.skipDataRefresh || layoutProvider.skipCartDataReload;
    
    // Only fetch data if we're not skipping data refresh
    if (!shouldSkipRefresh) {
      Future.microtask(() {
        final cartProvider = context.read<CartProvider>();
        cartProvider.fetchCartItems();
        cartProvider.fetchCartCount();
        cartProvider.fetchCartSummary();
      });
    }
  }
  
  @override
  void didUpdateWidget(CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      setState(() {
        _shouldAnimate = true;
      });
    }
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }


  Future<void> _applyCoupon(CouponProvider couponProvider) async {
    final couponCode = _promoCodeController.text.trim();
    if (couponCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_enter_coupon_code'.tr(context))),
      );
      return;
    }

    setState(() {
      _isApplyingCoupon = true;
    });

    try {
      await couponProvider.applyCoupon(couponCode);
      await context.read<CartProvider>().fetchCartSummary();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(couponProvider.appliedCoupon?.message ?? '')),
        );
      }

      if (couponProvider.appliedCoupon?.success == true) {
        _promoCodeController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingCoupon = false;
        });
      }
    }
  }

  Future<void> _removeCoupon(CouponProvider couponProvider) async {
    setState(() {
      _isApplyingCoupon = true;
    });

    try {
      await couponProvider.removeCoupon();
      await context.read<CartProvider>().fetchCartSummary();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar( SnackBar(content: Text('coupon_removed_successfully'.tr(context))));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingCoupon = false;
        });
      }
    }
  }

  void _handleItemDelete(int itemId) {
    // Mark item as being deleted to prevent layout jumps
    setState(() {
      _itemsBeingDeleted.add(itemId);
    });
    
    // Perform actual deletion
    context.read<CartProvider>().deleteCartItem(itemId).then((_) {
      if (mounted) {
        setState(() {
          _itemsBeingDeleted.remove(itemId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        // Display loading shimmer if needed
        if (cartProvider.cartState == LoadingState.loading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                'my_cart'.tr(context),
                style: context.displaySmall!.copyWith(fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
            ),
            body: const CartScreenShimmer(),
          );
        }

        // Display empty cart if needed
        if (cartProvider.cartItems.isEmpty) {
          return _shouldAnimate
            ? FadeIn(
                duration: const Duration(milliseconds: 600),
                child: const EmptyCartWidget(),
              )
            : const EmptyCartWidget();
        }

        // Display cart with items
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: _shouldAnimate
              ? FadeIn(
                  duration: const Duration(milliseconds: 400),
                  child: Text('my_cart'.tr(context),
                    style: context.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              : Text('my_cart'.tr(context),
                style: context.displaySmall!.copyWith(fontWeight: FontWeight.bold),
              ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Cart items in an expandable list
              Expanded(
                child: ListView.builder(
                  key: const PageStorageKey('cart_items_list'),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cartProvider.cartItems
                      .where((item) => !_itemsBeingDeleted.contains(item.id))
                      .length,
                  itemBuilder: (context, index) {
                    // Filter out items that are currently being deleted for visual display
                    final visibleItems = cartProvider.cartItems
                        .where((item) => !_itemsBeingDeleted.contains(item.id))
                        .toList();
                    
                    final CartItem item = visibleItems[index];
                    
                    // Use a unique key for each cart item based on its ID
                    return _shouldAnimate
                      ? FadeInUp(
                          key: ValueKey('cart_animation_${item.id}'),
                          delay: Duration(milliseconds: 50 * index),
                          duration: const Duration(milliseconds: 400),
                          child: SnappableCartItem(
                            key: ValueKey('cart_item_${item.id}'),
                            item: item,
                            index: index,
                            onQuantityChanged: (int quantity) {
                              _updateQuantity(cartProvider, item.id, quantity);
                            },
                            onDelete: _handleItemDelete,
                          ),
                        )
                      : SnappableCartItem(
                          key: ValueKey('cart_item_${item.id}'),
                          item: item,
                          index: index,
                          onQuantityChanged: (int quantity) {
                            _updateQuantity(cartProvider, item.id, quantity);
                          },
                          onDelete: _handleItemDelete,
                        );
                  },
                ),
              ),

              // Bottom sections - animate only once
              _shouldAnimate
                ? FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 500),
                    child: _buildCartSummary(context, cartProvider),
                  )
                : _buildCartSummary(context, cartProvider),
            ],
          ),
        );
      },
    );
  }

  void _updateQuantity(CartProvider cartProvider, int itemId, int newQuantity) {
    // Get current item to determine if this is an increment or decrement
    final CartItem? currentItem = cartProvider.cartItems.firstWhere(
      (item) => item.id == itemId, 
      orElse: () => null as CartItem,
    );
    final bool isDecrement = currentItem != null && newQuantity < currentItem.quantity;
    
    // Create a list of all cart IDs
    final cartIds = itemId.toString(); // Only update this specific item
    final quantitiesStr = newQuantity.toString(); // New quantity

    // Update cart quantities with operation type
    cartProvider.updateCartQuantities(cartIds, quantitiesStr, isDecrement: isDecrement);
  }

  Widget _buildCartSummary(BuildContext context, CartProvider cartProvider) {
    return Column(
      children: [
        // Order Summary
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Divider(color: AppTheme.lightDividerColor),
              _buildSummaryRow(
                'subtotal'.tr(context),
                '${cartProvider.cartSummary?.subtotal ?? 0.0}',
              ),

              _buildSummaryRow(
                'shipping_fee'.tr(context),
                '${cartProvider.cartSummary?.shippingCost.toStringAsFixed(2) ?? '0.00'} ${cartProvider.cartSummary?.currencySymbol ?? ''}',
              ),
              if (cartProvider.cartSummary?.couponApplied == true)
                _buildSummaryRow(
                  'discount'.tr(context),
                  '- ${cartProvider.cartSummary?.discount.toStringAsFixed(2) ?? '0.00'} ${cartProvider.cartSummary?.currencySymbol ?? ''}',
                  textColor: AppTheme.errorColor,
                ),
              _buildSummaryRow(
                'total'.tr(context),
                '${cartProvider.cartSummary!.total.toStringAsFixed(2) ?? '0.00'} ${cartProvider.cartSummary?.currencySymbol ?? ''}',
                isBold: true,
              ),
            ],
          ),
        ),

        // Discount Coupon Section
        Consumer<CouponProvider>(
          builder: (context, couponProvider, _) {
            final bool hasCoupon =
                couponProvider.appliedCoupon?.success == true ||
                cartProvider.cartSummary?.couponApplied == true;
            final String? couponCode =
                couponProvider.appliedCoupon?.couponCode ??
                cartProvider.cartSummary?.couponCode;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasCoupon && couponCode != null)
                    // Applied coupon UI
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  couponCode,
                                  style: context.titleMedium,
                                ),
                                Text(
                                  'coupon_applied'.tr(context),
                                  style: context.titleSmall,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed:
                                _isApplyingCoupon
                                    ? null
                                    : () =>
                                        _removeCoupon(couponProvider),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              foregroundColor: Colors.black87,
                            ),
                            child: Text(
                              'remove'.tr(context),
                              style: context.titleSmall!.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Coupon input
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _promoCodeController,

                            hint: 'enter_promo_code'.tr(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed:
                              _isApplyingCoupon
                                  ? null
                                  : () =>
                                      _applyCoupon(couponProvider),
                          child:
                              _isApplyingCoupon
                                  ? const CustomLoadingWidget()
                                  : Text(
                                    'apply'.tr(context),
                                    style: context.titleLarge!
                                        .copyWith(
                                          color:
                                              AppTheme.primaryColor,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),

        // Checkout Button
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          child: CustomButton(
            text: 'proceed_to_checkout'.tr(context),
            fullWidth: true,
            onPressed: () {
              AppRoutes.navigateTo(
                context,
                AppRoutes.newCheckoutScreen,
              );
            },
          ),
        ),

        /// Secure Checkout Text
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(
        //         Icons.lock_outline,
        //         size: 14,
        //         color: Colors.grey[600],
        //       ),
        //       const SizedBox(width: 6),
        //       Text('secure_checkout'.tr(context), style: context.bodySmall),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.titleMedium),
          Text(
            value,
            style: context.titleMedium!.copyWith(
              color: textColor ?? AppTheme.black,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
