import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/product%20cards/custom_product_card.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:leader_company/core/utils/widgets/see_all_widget.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/enums/products_type.dart';
import 'package:leader_company/features/presentation/home/controller/home_provider.dart';
import 'package:leader_company/features/presentation/home/widgets/shimmer/flash_deals_shimmer.dart';
import 'package:leader_company/core/utils/product cards/custom_product_row.dart';
import 'package:leader_company/features/domain/product/entities/flash_deal.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';

class FlashDealsWidget extends StatelessWidget {
  const FlashDealsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Show shimmer while loading
        if (homeProvider.flashDealProductsState == LoadingState.loading) {
          return const FlashDealsShimmer();
        }

        // Show error state
        if (homeProvider.flashDealProductsState == LoadingState.error) {
          return const SizedBox.shrink();
        }

        // Get flash deals data
        final deals = homeProvider.flashDeals;

        // Show empty state if no deals
        if (deals.isEmpty) {
          return const SizedBox.shrink();
        }

        // Create a list of sections, one for each flash deal
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              deals
                  .map((deal) => _buildFlashDealSection(context, deal))
                  .toList(),
        );
      },
    );
  }

  Widget _buildFlashDealSection(BuildContext context, FlashDeal deal) {
    // Filter published products
    final products = deal.products;

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner image if available
        if (deal.banner.isNotEmpty &&
            !deal.banner.toString().contains('placeholder'))
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  children: [
                    CustomImage(
                      imageUrl: deal.banner,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Color overlay
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4), // Slightly darker for better text contrast
                      ),
                    ),
                    // Text overlay
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top section - Deal info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Flash deal badge
                                const SizedBox(height: 15),
                                // Deal title
                                Text(
                                  'premium_dinnerware_collection'.tr(context),
                                  style: context.displaySmall!.copyWith(color: AppTheme.white,fontWeight: FontWeight.w600,fontSize: 22),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'discover_premium_quality_and_service'.tr(context),
                                  style: context.titleLarge!.copyWith(color: AppTheme.white.withValues(alpha: 0.7),fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            // Bottom section - Discount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Space for your countdown timer
                                Text(
                                  'ends_in'.tr(context),
                                  style: context.titleLarge!.copyWith(color: AppTheme.white,fontWeight: FontWeight.w600),
                                ),
                                FlashDealCountdown(endDate: deal.date),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


        SeeAllWidget(title: deal.title, onTap: () {
          AppRoutes.navigateTo(
            context,
            AppRoutes.allProductsByTypeScreen,
            arguments: {
              'productType': ProductType.flashDeal,
              'title': deal.title,
            },
          );
        },),

        const SizedBox(height: 10),

        // Products list
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder:
                (context, index) => ProductCard(
                  product: products[index],
                  isOutlinedAddToCart: true,
                ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

class FlashDealCountdown extends StatefulWidget {
  final int endDate;

  const FlashDealCountdown({super.key, required this.endDate});

  @override
  State<FlashDealCountdown> createState() => _FlashDealCountdownState();
}

class _FlashDealCountdownState extends State<FlashDealCountdown> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final endDate = DateTime.fromMillisecondsSinceEpoch(widget.endDate * 1000);

    if (endDate.isAfter(now)) {
      _remainingTime = endDate.difference(now);
    } else {
      _remainingTime = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        _calculateRemainingTime();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remainingTime.inHours;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 16,
            color: AppTheme.white,
          ),
          const SizedBox(width: 4),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: context.headlineSmall?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
