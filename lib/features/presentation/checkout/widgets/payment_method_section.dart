import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import '../../../../core/utils/extension/translate_extension.dart';
import '../../../domain/payment/entities/payment_type.dart';

class PaymentMethodSection extends StatelessWidget {
  final List<PaymentType> paymentTypes;
  final String selectedPaymentTypeKey;
  final Function(String) onPaymentTypeSelected;
  final bool isLoading;

  const PaymentMethodSection({
    super.key,
    required this.paymentTypes,
    required this.selectedPaymentTypeKey,
    required this.onPaymentTypeSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            _buildShimmerEffect(context)
          else if (paymentTypes.isEmpty)
            _buildEmptyState(context)
          else
            Column(
              children: paymentTypes.map((paymentType) {
                final isSelected = selectedPaymentTypeKey == paymentType.paymentTypeKey;
                return _buildPaymentMethodItem(
                  context,
                  paymentType,
                  isSelected,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withValues(alpha: 0.05),
            Colors.red.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.payment_outlined,
              size: 32,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'no_payment_methods'.tr(context),
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(2, (index) =>
        Container(
          width: double.infinity,
          height: 70,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(
      BuildContext context,
      PaymentType paymentType,
      bool isSelected,
      ) {
    Widget paymentIcon;
    bool isArabic = Directionality.of(context) == TextDirection.rtl;

    // Determine icon based on payment type key if image fails to load
    IconData getIconForPaymentType(String key) {
      switch (key) {
        case 'cash_on_delivery':
          return Icons.money;
        case 'wallet':
          return Icons.account_balance_wallet;
        case 'digital_wallet':
          return Icons.smartphone;
        case 'credit_card':
          return Icons.credit_card;
        case 'club_points':
          return Icons.star;
        default:
          return Icons.payment;
      }
    }

    // Default icon handling with error fallback
    paymentIcon = CustomImage(
      imageUrl: paymentType.image,
      width: 32,
      height: 24,
      fit: BoxFit.contain,
      errorWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          getIconForPaymentType(paymentType.paymentTypeKey),
          size: 20,
          color: AppTheme.primaryColor,
        ),
      ),
    );

    // Translate payment method name based on language
    String paymentMethodName = isArabic 
        ? _getArabicPaymentMethodName(paymentType.paymentTypeKey)
        : paymentType.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isSelected ? LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ) : null,
        color: isSelected ? null : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPaymentTypeSelected(paymentType.paymentTypeKey),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Custom Radio Button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                
                const SizedBox(width: 16),
                
                // Payment Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryColor.withValues(alpha: 0.2) 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: paymentIcon,
                ),
                
                const SizedBox(width: 16),
                
                // Payment Method Name
                Expanded(
                  child: Text(
                    paymentMethodName, 
                    style: context.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppTheme.primaryColor : Colors.black87,
                    ),
                  ),
                ),
                
                // Selected Indicator
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'selected'.tr(context),
                      style: context.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get Arabic translations for payment methods
  String _getArabicPaymentMethodName(String paymentTypeKey) {
    switch (paymentTypeKey) {
      case 'cash_on_delivery':
        return 'الدفع عند الاستلام';
      case 'wallet':
        return 'المحفظة';
      case 'cash_payment':
        return 'الدفع نقدا';
      case 'bank_payment':
        return 'تحويل بنكي';
      case 'kashier':
        return 'الدفع الالكترونى';
      case 'paypal':
        return 'باي بال';
      case 'stripe':
        return 'سترايب';
      case 'paytm':
        return 'باي تي إم';
      case 'sslcommerz':
        return 'إس إس إل كوميرز';
      case 'instamojo':
        return 'انستاموجو';
      case 'razorpay':
        return 'رازورباي';
      case 'paystack':
        return 'بايستاك';
      case 'voguepay':
        return 'فوجباي';
      case 'payhere':
        return 'باي هير';
      case 'ngenius':
        return 'إن جينيوس';
      case 'iyzico':
        return 'إيزيكو';
      case 'bkash':
        return 'بي كاش';
      case 'nagad':
        return 'ناجاد';
      case 'flutterwave':
        return 'فلاترويف';
      case 'mpesa':
        return 'إم بيسا';
      case 'mercadopago':
        return 'ميركادو باجو';
      case 'digital_wallet':
        return 'المحفظة الرقمية';
      case 'credit_card':
        return 'بطاقة ائتمان';
      case 'club_points':
        return 'نقاط النادي';
      default:
        return paymentTypeKey;
    }
  }
}