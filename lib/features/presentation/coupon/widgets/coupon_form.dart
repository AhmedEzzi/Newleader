import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';
import '../../../../core/utils/widgets/custom_button.dart';

class CouponForm extends StatefulWidget {
  final Function(String) onApplyCoupon;

  const CouponForm({
    Key? key,
    required this.onApplyCoupon,
  }) : super(key: key);

  @override
  State<CouponForm> createState() => _CouponFormState();
}

class _CouponFormState extends State<CouponForm> {
  final _couponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isApplying = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(
            controller: _couponController,
            label: 'coupon_code'.tr(context),
            hint: 'enter_coupon_code'.tr(context),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_coupon_code'.tr(context);
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _couponController.clear(),
            ),
          ),

          const SizedBox(height: 16),

          CustomButton(
            text: 'apply_coupon'.tr(context),
            isLoading: _isApplying,
            onPressed: _submitCoupon,
          ),
        ],
      ),
    );
  }

  void _submitCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isApplying = true;
    });

    try {
      final couponCode = _couponController.text.trim();
      await widget.onApplyCoupon(couponCode);
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }
}