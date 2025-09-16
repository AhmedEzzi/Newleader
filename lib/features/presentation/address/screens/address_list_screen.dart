import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../controller/address_provider.dart';
import '../widgets/address_item.dart';
import '../widgets/shimmer/address_list_shimmer.dart';
import '../widgets/empty_address_widget.dart';
import 'add_edit_address_screen.dart';
import '../../cart/controller/cart_provider.dart';

class AddressListScreen extends StatefulWidget {
  final bool isSelectable;

  const AddressListScreen({super.key, this.isSelectable = false});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  // Handle setting an address as default and update shipping
  Future<void> _handleSetDefault(int addressId) async {
    final addressProvider = context.read<AddressProvider>();
    
    try {
      // First make the address default
      await addressProvider.makeAddressDefault(addressId);
      
      // Then update address in cart and shipping
      await addressProvider.updateAddressInCart(
        addressId,
        context: context,
      );
      
      // Update cart summary to reflect shipping changes
      await context.read<CartProvider>().fetchCartSummary();
      
      // Show a confirmation message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'address_set_as_default'.tr(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message if something went wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'error_setting_default_address'.tr(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: const CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Text(
            'my_addresses'.tr(context), 
            style: context.displaySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 100),
            child: IconButton(
              onPressed: () => _navigateToAddAddress(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          // Show shimmer while loading
          if (addressProvider.addressState == LoadingState.loading) {
            return const AddressListShimmer();
          }
          // Show error state
          else if (addressProvider.addressState == LoadingState.error) {
            return Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 40,
                          color: Colors.red[400],
                        ),
                      ),
                      const SizedBox(height: 24),
                                              Text(
                          'error_occurred'.tr(context),
                          style: context.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      const SizedBox(height: 8),
                                              Text(
                          'failed_to_load_addresses'.tr(context),
                          style: context.bodyLarge.copyWith(
                            color: Colors.grey[600],
                          ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            addressProvider.fetchAddresses();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 20),
                          label: Text(
                            'try_again'.tr(context),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          // Show empty state
          else if (addressProvider.addresses.isEmpty) {
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: EmptyAddressWidget(
                onAddAddress: () => _navigateToAddAddress(context),
              ),
            );
          }

          // Show address list
          return Column(
            children: [
              // Header info card
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.1),
                        AppTheme.primaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'my_saved_addresses'.tr(context),
                              style: context.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'saved_address_count'.tr(context).replaceAll('{count}', '${addressProvider.addresses.length}'),
                              style: context.bodyMedium.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Address list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: addressProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = addressProvider.addresses[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: Duration(milliseconds: 100 * index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: AddressItem(
                          address: address,
                          isDefault: address.isDefault,
                          onEdit: () => _navigateToEditAddress(context, address.id),
                          onDelete: () => _showDeleteConfirmation(context, address.id),
                          onSetDefault: () => _handleSetDefault(address.id),
                          onSelect: widget.isSelectable 
                            ? () => Navigator.pop(context, address)
                            : null,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Modern Add New Address Button
              _buildModernAddButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModernAddButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.grey[300]!,
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Add button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                onPressed: () => _navigateToAddAddress(context),
                child: Text(
                  'add_new_address'.tr(context),
                  textAlign: TextAlign.center,
                  style: context.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddEditAddressScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ).then((_) {
      // Refresh the address list when returning from add screen
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  void _navigateToEditAddress(BuildContext context, int addressId) {
    final addressProvider = context.read<AddressProvider>();
    final address = addressProvider.addresses.firstWhere(
      (addr) => addr.id == addressId,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddEditAddressScreen(address: address),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ).then((_) {
      // Refresh the address list when returning from edit screen
      addressProvider.fetchAddresses();
    });
  }

  void _showDeleteConfirmation(BuildContext context, int addressId) {
    showCustomConfirmationDialog(
      context: context,
      title: 'delete_address'.tr(context),
      message: 'delete_address_confirmation'.tr(context),
      confirmText: 'delete'.tr(context),
      cancelText: 'cancel'.tr(context),
      confirmButtonColor: Colors.red[400]!,
      icon: Icons.delete_outline,
      onConfirm: () {
        context.read<AddressProvider>().deleteAddress(addressId);
      },
    );
  }
}
