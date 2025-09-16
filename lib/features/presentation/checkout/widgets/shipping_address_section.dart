import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../domain/address/entities/address.dart';

class ShippingAddressSection extends StatefulWidget {
  final Address? selectedAddress;
  final List<Address> addresses;
  final Function(Address) onAddressSelected;
  final VoidCallback onChangePressed;
  final Function(int) onEditPressed;
  final bool isLoading;

  const ShippingAddressSection({
    super.key,
    required this.selectedAddress,
    required this.addresses,
    required this.onAddressSelected,
    required this.onChangePressed,
    required this.onEditPressed,
    this.isLoading = false,
  });

  @override
  State<ShippingAddressSection> createState() => _ShippingAddressSectionState();
}

class _ShippingAddressSectionState extends State<ShippingAddressSection> {
  bool _initialSelectionDone = false;

  @override
  void didUpdateWidget(ShippingAddressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If addresses loaded for the first time, select default
    if (oldWidget.addresses.isEmpty && 
        widget.addresses.isNotEmpty && 
        !_initialSelectionDone && 
        widget.selectedAddress == null) {
      _selectDefaultAddress();
    }
  }

  void _selectDefaultAddress() {
    final defaultAddress = widget.addresses
        .where((address) => address.isDefault)
        .firstOrNull;

    if (defaultAddress != null && 
        widget.selectedAddress?.id != defaultAddress.id &&
        !widget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAddressSelected(defaultAddress);
        _initialSelectionDone = true;
      });
    } else if (widget.addresses.isNotEmpty && 
              widget.selectedAddress == null && 
              !widget.isLoading) {
      // If no default address, select the first one
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAddressSelected(widget.addresses.first);
        _initialSelectionDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = AppStrings.token == null;
    
    // Only auto-select default address on first load, not after user selection
    if (!_initialSelectionDone && widget.addresses.isNotEmpty && widget.selectedAddress == null) {
      _selectDefaultAddress();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isLoading)
            _buildShimmerEffect(context)
          else if ((isGuest && widget.selectedAddress == null) || 
                   (widget.addresses.isEmpty && !isGuest))
            _buildAddAddressPrompt(context, isGuest)
          else
            _buildSelectedAddress(context, isGuest),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildAddAddressPrompt(BuildContext context, bool isGuest) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.05),
            AppTheme.primaryColor.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 32,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'enter_shipping_address'.tr(context),
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'add_delivery_address_to_continue'.tr(context),
            style: context.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onChangePressed,
                borderRadius: BorderRadius.circular(24),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'add_address'.tr(context),
                        style: context.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddress(BuildContext context, bool isGuest) {
    // For both guest and logged-in users, only show the selected/default address
    final displayAddress = widget.selectedAddress;
    
    if (displayAddress == null) {
      return _buildAddAddressPrompt(context, isGuest);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayAddress.title.isNotEmpty 
                          ? displayAddress.title 
                          : 'delivery_address'.tr(context),
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (displayAddress.isDefault)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'default'.tr(context),
                          style: context.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: widget.onChangePressed,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Address Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressInfoRow(
                  Icons.person_outline,
                  AppStrings.userName ?? 'guest_user'.tr(context),
                ),
                const SizedBox(height: 8),
                _buildAddressInfoRow(
                  Icons.location_on_outlined,
                  displayAddress.address,
                ),
                const SizedBox(height: 8),
                _buildAddressInfoRow(
                  Icons.location_city_outlined,
                  "${displayAddress.cityName}, ${displayAddress.countryName}",
                ),
                if (displayAddress.postalCode.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildAddressInfoRow(
                    Icons.markunread_mailbox_outlined,
                    displayAddress.postalCode,
                  ),
                ],
                const SizedBox(height: 8),
                _buildAddressInfoRow(
                  Icons.phone_outlined,
                  displayAddress.phone,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: context.bodyMedium?.copyWith(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
