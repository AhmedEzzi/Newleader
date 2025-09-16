import 'package:leader_company/features/presentation/main%20layout/controller/layout_provider.dart';
import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:provider/provider.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/features/presentation/category/controller/provider.dart';
import 'package:leader_company/features/presentation/home/widgets/category_card.dart';
import 'package:leader_company/features/presentation/home/widgets/shimmer/categories_shimmer.dart';

import '../../../../core/utils/widgets/see_all_widget.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Calculate responsive dimensions based on screen size
    double horizontalPadding = screenWidth * 0.03; // 3% of screen width
    double crossAxisSpacing = screenWidth * 0.03; // 3% of screen width
    double mainAxisSpacing = screenHeight * 0.01; // 1% of screen height
    
    // Calculate card dimensions responsively
    final availableWidth = screenWidth - (horizontalPadding * 2) - crossAxisSpacing;
    final cardWidth = availableWidth / 2;
    
    // Responsive aspect ratio based on screen size
    double aspectRatio;
    if (screenHeight < 700) {
      // Smaller screens (like iPhone SE, small Android phones)
      aspectRatio = 0.85;
    } else if (screenHeight < 800) {
      // Medium screens (like iPhone 12, most Android phones)
      aspectRatio = 0.9;
    } else {
      // Larger screens (like iPhone Pro Max, large Android phones)
      aspectRatio = 0.95;
    }
    
    // Calculate total height responsively
    final cardHeight = cardWidth / aspectRatio;
    final seeAllHeight = 50.0;
    final spacingBetween = 8.0;
    final totalHeight = (cardHeight * 2) + mainAxisSpacing + seeAllHeight + spacingBetween;
    
    // Ensure minimum and maximum heights
    final constrainedHeight = totalHeight.clamp(
      screenHeight * 0.35, // Minimum 35% of screen height
      screenHeight * 0.5,  // Maximum 50% of screen height
    );
    
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        // Show shimmer while loading
        if (categoryProvider.categoriesState == LoadingState.loading) {
          return const CategoriesShimmer();
        }

        // Show error state
        if (categoryProvider.categoriesState == LoadingState.error) {
          return _buildEmptyState();
        }

        // Get categories data
        final categories = categoryProvider.categoriesResponse?.data ?? [];

        // Show empty state if no categories
        if (categories.isEmpty) {
          return _buildEmptyState();
        }

        // Only display first 4 categories
        final displayCategories = categories.take(4).toList();

        return Container(
          height: constrainedHeight,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SeeAllWidget(
                title: '',
                onTap: () {
                  Provider.of<LayoutProvider>(context,listen: false).currentIndex=1;
                },
              ),
              SizedBox(height: spacingBetween),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayCategories.length > 4 ? 4 : displayCategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: mainAxisSpacing,
                    crossAxisSpacing: crossAxisSpacing,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final category = displayCategories[index];
                    return HorizontalCategoryCard(
                      imageUrl: category.coverImage ?? '',
                      name: category.name ?? '',
                      onTap: () {
                        AppRoutes.navigateTo(
                          context,
                          AppRoutes.allCategoryProductsScreen,
                          arguments: {'category': category},
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }
}