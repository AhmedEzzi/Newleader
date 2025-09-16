import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/utils/extension/text_style_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/cutsom_toast.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../domain/address/entities/address.dart';
import '../controller/address_provider.dart';
import '../widgets/address_form_fields.dart';
import '../widgets/shimmer/address_form_shimmer.dart';
import '../../../domain/address/extensions/location_extensions.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  int? _selectedCountryId;
  int? _selectedStateId;

  bool _isLoading = false;
  bool _isLoadingStates = false;

  @override
  void initState() {
    super.initState();

    // Default country to Egypt (ID: 64)
    _selectedCountryId = 64;

    // If editing an existing address, populate the form
    if (widget.address != null) {
      _addressController.text = widget.address!.address;
      _phoneController.text = widget.address!.phone;
      _cityNameController.text = widget.address!.cityName;
      _selectedStateId = widget.address!.stateId;
      if (widget.address!.countryId != 0) {
        _selectedCountryId = widget.address!.countryId;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountryData();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _cityNameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _loadCountryData() async {
    setState(() {
      _isLoadingStates = true;
    });
    try {
      final addressProvider = context.read<AddressProvider>();
      
      // Always load states for Egypt (ID: 64)
      await addressProvider.fetchStatesByCountry(64);
      
    } catch (e) {
      if (mounted) {
        CustomToast.showToast(
          message: '${'error_loading_states'.tr(context)}: ${e.toString()}',
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStates = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        leading: const CustomBackButton(),
        backgroundColor: AppTheme.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: FadeIn(
          duration: const Duration(milliseconds: 400),
          child: Text(
            widget.address == null
              ? 'add_new_address'.tr(context)
              : 'edit_address'.tr(context),
            style: context.displaySmall.copyWith(
              fontWeight: FontWeight.w500,
            )
          ),
        ),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          // Show shimmer while loading states
          final bool isLoadingInitialData = _isLoadingStates || 
              (addressProvider.states.isEmpty && addressProvider.addressState == LoadingState.loading);

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: isLoadingInitialData
                      ? const AddressFormShimmer()
                      : FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: AddressFormFields(
                            addressController: _addressController,
                            phoneController: _phoneController,
                            cityNameController: _cityNameController,
                            selectedCountryId: _selectedCountryId, // Fixed to Egypt
                            selectedStateId: _selectedStateId,
                            fullNameController: _fullNameController,
                            countries: const [
                              {'id': 64, 'name': 'Egypt'} // Fixed to Egypt
                            ],
                            states: addressProvider.states
                                .map((location) => location.toMap())
                                .toList(),
                            isLoading: _isLoading,
                            onCountryChanged: (value) async {
                              // Country is fixed to Egypt, so this is not needed
                              // but keep it for the interface compatibility
                              if (value != null) {
                                setState(() {
                                  _selectedCountryId = 64; // Always Egypt
                                });
                              }
                            },
                            onStateChanged: (value) async {
                              if (value != null) {
                                setState(() {
                                  _selectedStateId = value;
                                });
                              }
                            },
                          ),
                        ),
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              isOutlined: true,
              child: Text(
                'cancel'.tr(context),
                textAlign: TextAlign.center,
                style: context.headlineSmall.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isLoading
                ? const CustomLoadingWidget()
                : CustomButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                      'save'.tr(context),
                      textAlign: TextAlign.center,
                      style: context.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ),
          ),
        ],
      ),
    );
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final addressProvider = context.read<AddressProvider>();
        final cityName = _cityNameController.text.trim();

        if (widget.address == null) {
          // Add new address
          await addressProvider.addAddress(
            address: _addressController.text,
            countryId: 64, // Egypt is always selected
            stateId: _selectedStateId!,
            cityName: cityName,
            phone: _phoneController.text,
          );

          if (mounted) {
            CustomToast.showToast(
              message: 'address_saved_successfully'.tr(context),
              type: ToastType.success,
            );
            Navigator.pop(context);
          }
        } else {
          // Update existing address
          await addressProvider.updateAddress(
            id: widget.address!.id,
            address: _addressController.text,
            countryId: 64, // Egypt is always selected
            stateId: _selectedStateId!,
            cityName: cityName,
            phone: _phoneController.text,
          );

          if (mounted) {
            CustomToast.showToast(
              message: 'address_updated_successfully'.tr(context),
              type: ToastType.success,
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          CustomToast.showToast(
          message: '${'error_saving_address'.tr(context)}: ${e.toString()}',
            type: ToastType.error,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
