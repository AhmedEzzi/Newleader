import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../domain/address/entities/address.dart';
import '../../address/controller/address_provider.dart';
import '../../address/screens/address_list_screen.dart';
import '../../address/screens/add_edit_address_screen.dart';
import '../../cart/controller/cart_provider.dart';
import '../controller/payment_provider.dart';
import '../widgets/geust_address_form.dart';
import '../widgets/shipping_address_section.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/order_summary_section.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  bool _isProcessingPayment = false;
  
  bool get _isGuestUser => AppStrings.token == null;

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    final addressProvider = context.read<AddressProvider>();
    final paymentProvider = context.read<PaymentProvider>();
    final cartProvider = context.read<CartProvider>();

    if (_isGuestUser) {
      // For guest users, we only load checkout types and cart summary
      await Future.wait([
        paymentProvider.fetchPaymentTypes(),
        cartProvider.fetchCartSummary(),
      ]);
    } else {
      // For logged in users, load addresses as well
      await Future.wait([
        addressProvider.fetchAddresses(),
        paymentProvider.fetchPaymentTypes(),
        cartProvider.fetchCartSummary(),
      ]);

      if (addressProvider.addresses.isNotEmpty && mounted) {
        // First try to find a default address
        Address? defaultAddress = addressProvider.addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addressProvider.addresses.first,
        );

        setState(() {
          _selectedAddress = defaultAddress;
        });

        // Update shipping with the default address
        await _updateShippingWithSelectedAddress(paymentProvider);
            }
    }
  }

  Future<void> _updateShippingWithSelectedAddress(
    PaymentProvider paymentProvider,
  ) async {
    if (_selectedAddress == null) return;

    try {
      if (_isGuestUser) {
        await context.read<PaymentProvider>().updateShippingTypeForGuest(
          stateId: _selectedAddress!.stateId,
          address: _selectedAddress!.address,
        );
      } else {
        // Update address in cart for logged in users and pass context to update shipping
        await context.read<AddressProvider>().updateAddressInCart(
          _selectedAddress!.id,
          context: context,
        );
      }
      await context.read<CartProvider>().fetchCartSummary();
    } catch (e) {
      debugPrint('Error updating shipping: $e');
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _navigateToAddressList() async {
    if (_isGuestUser) {
      _navigateToGuestAddressForm();
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressListScreen(isSelectable: true),
      ),
    );

    if (result != null && result is Address) {
      // If an address was explicitly selected in the address list
      setState(() {
        _selectedAddress = result;
      });
      await _updateShippingWithSelectedAddress(context.read<PaymentProvider>());
    } else {
      // If no address was explicitly selected, get the default address
      // This handles the case when a user sets a new default address but doesn't select it
      final addressProvider = context.read<AddressProvider>();
      
      // Refresh addresses to get the latest default
      await addressProvider.fetchAddresses();
      
      if (addressProvider.addresses.isNotEmpty) {
        final defaultAddress = addressProvider.addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addressProvider.addresses.first,
        );
        
        // Only update if the default address is different from the current selection
        if (_selectedAddress == null || defaultAddress.id != _selectedAddress!.id) {
          setState(() {
            _selectedAddress = defaultAddress;
          });
          await _updateShippingWithSelectedAddress(context.read<PaymentProvider>());
        }
      }
    }
  }

  void _navigateToGuestAddressForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                GuestAddressFormScreen(initialAddress: _selectedAddress),
      ),
    );

    if (result != null && result is Address) {
      onAddressSelected(result);
    }
  }

  void onAddressSelected(Address address) async {
    // Don't do anything if address is already selected
    if (_selectedAddress?.id == address.id) return;
    
    setState(() {
      _selectedAddress = address;
    });
    
    // Making the selected address the default one if user is logged in
    if (!_isGuestUser && !address.isDefault) {
      try {
        await context.read<AddressProvider>().makeAddressDefault(address.id);
      } catch (e) {
        // Silently handle the error - the address selection will still work
        debugPrint('Error setting address as default: $e');
      }
    }
    
    _updateShippingWithSelectedAddress(context.read<PaymentProvider>());
  }

  void _navigateToEditAddress(int addressId) async {
    if (_isGuestUser) {
      _navigateToGuestAddressForm();
      return;
    }

    final addressProvider = context.read<AddressProvider>();
    final address = addressProvider.addresses.firstWhere(
      (addr) => addr.id == addressId,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(address: address),
      ),
    );

    await addressProvider.fetchAddresses();

    if (_selectedAddress?.id == addressId && mounted) {
      final updatedAddress = addressProvider.addresses.firstWhere(
        (addr) => addr.id == addressId,
        orElse: () => _selectedAddress!,
      );

      setState(() {
        _selectedAddress = updatedAddress;
      });

      await _updateShippingWithSelectedAddress(context.read<PaymentProvider>());
    }
  }

  Future<void> _processPayment() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('select_delivery_address'.tr(context))),
      );
      return;
    }

    if (_selectedAddress!.address.isEmpty ||
        _selectedAddress!.phone.isEmpty ||
        _selectedAddress!.stateId <= 0 ||
        _selectedAddress!.cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('missing_address_fields'.tr(context))),
      );
      return;
    }

    final paymentProvider = context.read<PaymentProvider>();
    if (paymentProvider.selectedPaymentTypeKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('select_payment_method'.tr(context))),
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final response = await paymentProvider.createOrder(
        postalCode: _selectedAddress!.postalCode,
        stateId: _selectedAddress!.stateId.toString(),
        address: _selectedAddress!.address,
        city: _selectedAddress!.cityName,
        phone: _selectedAddress!.phone,
        additionalInfo: _noteController.text ?? '',
        context: context,
      );

      if (response.result && mounted) {
        await context.read<CartProvider>().fetchCartItems();
        await context.read<CartProvider>().fetchCartCount();

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.successScreen,
          (route) => route.settings.name == AppRoutes.homeScreen,
        );
      } else if (!response.result && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
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
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withValues(alpha: 0.05),
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Gradient
            SliverAppBar(
              expandedHeight: 20,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: const CustomBackButton(),
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          'checkout'.tr(context),
                          style: context.headlineMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Consumer3<AddressProvider, PaymentProvider, CartProvider>(
                builder: (context, addressProvider, paymentProvider, cartProvider, _) {
                  final bool isLoading =
                      (!_isGuestUser &&
                          addressProvider.addressState == LoadingState.loading) ||
                      paymentProvider.paymentTypesState == LoadingState.loading ||
                      cartProvider.cartState == LoadingState.loading;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        /// Progress Indicator
                        // FadeInUp(
                        //   duration: const Duration(milliseconds: 600),
                        //   child: _buildProgressIndicator(),
                        // ),
                        //
                        // const SizedBox(height: 24),
                        
                        // Shipping Address Section
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 600),
                          child: _buildModernSection(
                            icon: Icons.location_on,
                            title: 'shipping_address'.tr(context),
                            child: ShippingAddressSection(
                              selectedAddress: _selectedAddress,
                              addresses: _isGuestUser ? [] : addressProvider.addresses,
                              onAddressSelected: (address) {
                                setState(() {
                                  _selectedAddress = address;
                                });
                                _updateShippingWithSelectedAddress(paymentProvider);
                              },
                              onChangePressed: _navigateToAddressList,
                              onEditPressed: _navigateToEditAddress,
                              isLoading: isLoading,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Payment Method Section
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          duration: const Duration(milliseconds: 600),
                          child: _buildModernSection(
                            icon: Icons.payment,
                            title: 'payment_method'.tr(context),
                            child: PaymentMethodSection(
                              paymentTypes: paymentProvider.paymentTypes,
                              selectedPaymentTypeKey:
                                  paymentProvider.selectedPaymentTypeKey,
                              onPaymentTypeSelected: paymentProvider.selectPaymentType,
                              isLoading: isLoading,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Order Summary Section
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          duration: const Duration(milliseconds: 600),
                          child: _buildModernSection(
                            icon: Icons.receipt_long,
                            title: 'order_summary'.tr(context),
                            child: OrderSummarySection(
                              cartSummary: cartProvider.cartSummary!,
                              cartItems: cartProvider.cartItems,
                              isUpdatingShipping:
                                  paymentProvider.shippingUpdateState ==
                                  LoadingState.loading,
                              shippingError: paymentProvider.errorMessage,
                              isInitialLoading: isLoading, 
                              noteController: _noteController,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Place Order Button
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          duration: const Duration(milliseconds: 600),
                          child: Consumer<PaymentProvider>(
                            builder: (context, paymentProvider, _) {
                              final bool isLoading = paymentProvider.paymentTypesState == LoadingState.loading;

                              if (isLoading || _isProcessingPayment) {
                                return Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryColor.withValues(alpha: 0.7),
                                        AppTheme.primaryColor.withValues(alpha: 0.5),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: const Center(
                                    child: CustomLoadingWidget(),
                                  ),
                                );
                              }

                              return Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.primaryColor.withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _processPayment,
                                    borderRadius: BorderRadius.circular(28),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'place_order'.tr(context),
                                            style: context.titleLarge?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProgressStep(1, 'cart'.tr(context), true),
          _buildProgressLine(true),
          _buildProgressStep(2, 'checkout'.tr(context), true),
          _buildProgressLine(false),
          _buildProgressStep(3, 'payment'.tr(context), false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor : Colors.grey[200],
            shape: BoxShape.circle,
            boxShadow: isActive ? [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.primaryColor : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppTheme.primaryColor : Colors.grey[300],
    );
  }

  Widget _buildModernSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Section Content
          child,
        ],
      ),
    );
  }
}
