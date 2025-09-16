import 'package:flutter/material.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_back_button.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_form_field.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../domain/address/entities/address.dart';
import '../../address/controller/address_provider.dart';

class GuestAddressFormScreen extends StatefulWidget {
  final Address? initialAddress;

  const GuestAddressFormScreen({
    super.key,
    this.initialAddress,
  });

  @override
  State<GuestAddressFormScreen> createState() => _GuestAddressFormScreenState();
}

class _GuestAddressFormScreenState extends State<GuestAddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityNameController = TextEditingController();

  int _selectedCountryId = 0;
  int _selectedStateId = 0;
  String _selectedCountryName = '';
  String _selectedStateName = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialAddress != null) {
      _phoneController.text = widget.initialAddress!.phone;
      _addressController.text = widget.initialAddress!.address;
      _cityNameController.text = widget.initialAddress!.cityName;
      _selectedCountryId = widget.initialAddress!.countryId;
      _selectedStateId = widget.initialAddress!.stateId;
      _selectedCountryName = widget.initialAddress!.countryName;
      _selectedStateName = widget.initialAddress!.stateName;
      _nameController.text = AppStrings.userName!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    final addressProvider = context.read<AddressProvider>();

    try {
      await addressProvider.fetchCountries();

      if (_selectedCountryId > 0) {
        await addressProvider.fetchStatesByCountry(_selectedCountryId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityNameController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCountryId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_select_country'.tr(context))),
      );
      return;
    }

    if (_selectedStateId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_select_state'.tr(context))),
      );
      return;
    }

    final cityName = _cityNameController.text.trim();
    if (cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_enter_city_name'.tr(context))),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final guestAddress = Address(
        id: widget.initialAddress?.id ?? -1,
        address: _addressController.text,
        countryId: _selectedCountryId,
        stateId: _selectedStateId,
        cityId: 0,
        countryName: _selectedCountryName,
        stateName: _selectedStateName,
        cityName: cityName,
        postalCode: '',
        phone: _phoneController.text,
        latitude: 0.0,
        longitude: 0.0,
        isDefault: true,
        locationAvailable: false,
      );
      AppStrings.userName=_nameController.text;

      Navigator.pop(context, guestAddress);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shipping_address'.tr(context)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const CustomBackButton(),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Country Dropdown
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'country'.tr(context),
                    border: const OutlineInputBorder(),
                  ),
                  value: _selectedCountryId > 0 ? _selectedCountryId : null,
                  hint: Text('select_country'.tr(context)),
                  items: addressProvider.countries.map((country) {
                    return DropdownMenuItem<int>(
                      value: country.id,
                      child: Text(country.name),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        _selectedCountryId = value;
                        _selectedStateId = 0;
                        _selectedCountryName = addressProvider.countries
                            .firstWhere((country) => country.id == value)
                            .name;
                      });

                      await addressProvider.fetchStatesByCountry(value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // State Dropdown
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'state'.tr(context),
                    border: const OutlineInputBorder(),
                  ),
                  value: _selectedStateId > 0 ? _selectedStateId : null,
                  hint: Text('select_state'.tr(context)),
                  items: addressProvider.states.map((state) {
                    return DropdownMenuItem<int>(
                      value: state.id,
                      child: Text(state.name),
                    );
                  }).toList(),
                  onChanged: addressProvider.states.isEmpty
                      ? null
                      : (value) async {
                    if (value != null) {
                      setState(() {
                        _selectedStateId = value;
                        _selectedStateName = addressProvider.states
                            .firstWhere((state) => state.id == value)
                            .name;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // City Text Field (replacing dropdown)
                CustomTextFormField(
                  controller: _cityNameController,
                  hint: 'enter_city_name'.tr(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_city_name'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _nameController,
                  hint: 'name'.tr(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_your_name'.tr(context);
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                // Phone
                CustomTextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hint: 'phone'.tr(context),
                  isMobileNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_phone'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address
                CustomTextFormField(
                  controller: _addressController,
                  maxLines: 1,
                  hint: 'address'.tr(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_address'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Save Button
                _isLoading
                    ? const CustomLoadingWidget()
                    : CustomButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  child: Text(
                    'save_address'.tr(context),
                    textAlign: TextAlign.center,
                    style: context.titleMedium!.copyWith(color: AppTheme.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}