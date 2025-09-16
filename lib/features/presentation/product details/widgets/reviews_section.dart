import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_button.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/core/utils/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../review/controller/reviews_provider.dart';
import '../../review/screens/products_review_screen.dart';
import '../../review/widgets/add_review_dialog.dart';
import '../../review/widgets/review_card.dart';

class ReviewsSectionWidget extends StatefulWidget {
  final int productId;
  const ReviewsSectionWidget({super.key, required this.productId});

  @override
  State<ReviewsSectionWidget> createState() => _ReviewsSectionWidgetState();
}

class _ReviewsSectionWidgetState extends State<ReviewsSectionWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'customer_reviews'.tr(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllReviewsScreen(
                            productId: widget.productId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'see_all_reviews'.tr(context),
                      style: context.bodyLarge!.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reviews Carousel
              if (reviewProvider.reviewState == LoadingState.loading)
                const Center(child: CustomLoadingWidget())
              else if (reviewProvider.reviews.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('no_reviews_yet_be'.tr(context)),
                        const SizedBox(height: 16),
                        _buildWriteReviewButton(),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 210,
                        aspectRatio: 16/9,
                        viewportFraction: 0.85,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlay: reviewProvider.reviews.length > 1,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        initialPage: _currentIndex,
                      ),
                      items: reviewProvider.reviews.map((review) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ReviewCard(review: review),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    // Indicators
                    if (reviewProvider.reviews.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          reviewProvider.reviews.length,
                              (index) => Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? const Color(0xFFB84C43)
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildWriteReviewButton(),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWriteReviewButton() {
    return CustomButton(
      text: 'write_review'.tr(context),
      onPressed: () => _showAnimatedReviewDialog(),
    );
  }

  void _showAnimatedReviewDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
          ),
          child: AddReviewDialog(productId: widget.productId),
        );
      },
    );
  }
}
