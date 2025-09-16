import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/features/presentation/checkout/controller/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/payment/models/payment_type_model.dart';
import '../../main layout/controller/layout_provider.dart';

class SuccessScreen extends StatelessWidget {
  SuccessScreen({super.key, required this.orderDetails});
  final OrderResponseModel orderDetails;

  @override
  Widget build(BuildContext context) {
    PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    
    // Format the order number
    String orderNumber = "#ORD-${orderDetails.combinedOrder!.id}";


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Success check icon
              Lottie.asset(AppAnimations.successCheckout,fit: BoxFit.contain,height: 200,width: 200,repeat: false),
              const SizedBox(height: 40),

              // Thank you heading
              Center(
                child: Text('thank_you'.tr(context),
                  style: context.displaySmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Order confirmation message
              Center(
                child: Text('your_order_has_been_successfully_placed'.tr(context),
                  style: context.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Order details card
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Order number row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('order_number'.tr(context),
                          style: context.titleLarge?.copyWith(
                          ),
                        ),
                        Text(
                          orderNumber,
                          style: context.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Estimated delivery row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('estimated_delivery'.tr(context),
                          style: context.titleLarge?.copyWith(
                          ),
                        ),
                        Text(
                          '3-5 ${"days".tr(context)}',
                          style: context.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Track Order button
             AppStrings.token==null?const SizedBox.shrink(): CustomButton(
                onPressed: () {
                  if (AppStrings.token != null) {
                    Provider.of<LayoutProvider>(context, listen: false).currentIndex = 4;
                    AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
                  }
                },
                backgroundColor: AppTheme.primaryColor,
                child: Center(
                  child: Text(
                    "track_order".tr(context),
                    style: context.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Continue Shopping button
              CustomButton(
                onPressed: () {
                  Provider.of<LayoutProvider>(context, listen: false).currentIndex = 0;
                  AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.mainLayoutScreen);
                },
                isOutlined: true,
                backgroundColor: AppTheme.primaryColor,
                child: Center(
                  child: Text(
                    "continue_shopping".tr(context),
                    style: context.headlineSmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 80)
            ],
          ),
        ),
      ),
    );
  }

}