import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:leader_company/core/config/app_config.dart/app_config.dart';
import 'package:leader_company/core/config/routes.dart/routes.dart';
import 'package:leader_company/core/config/themes.dart/theme.dart';
import 'package:leader_company/core/utils/constants/app_assets.dart';
import 'package:leader_company/core/utils/extension/text_theme_extension.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/core/utils/widgets/custom_cached_image.dart';
import 'package:leader_company/features/domain/category/entities/category.dart';

class CategoryWidget extends StatefulWidget {
  final List<Category> categories;
  final bool triggerAnimation;

  const CategoryWidget({
    super.key, 
    required this.categories,
    this.triggerAnimation = true,
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> with SingleTickerProviderStateMixin {
  bool _shouldAnimate = false;

  @override
  void initState() {
    super.initState();
    _shouldAnimate = widget.triggerAnimation;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void didUpdateWidget(CategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When triggerAnimation changes, update animation state
    if (widget.triggerAnimation != oldWidget.triggerAnimation) {
      setState(() {
        _shouldAnimate = widget.triggerAnimation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return Center(child: Text('no_categories_available'.tr(context)));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: _shouldAnimate 
          ? FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Text('categories'.tr(context),
                style: context.headlineSmall!.copyWith(fontWeight: FontWeight.w700)
              ),
            )
          : Text('categories'.tr(context),
              style: context.headlineSmall!.copyWith(fontWeight: FontWeight.w700)
            ),
        actions: [
          _shouldAnimate 
            ? FadeInRight(
                duration: const Duration(milliseconds: 500),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    AppRoutes.navigateTo(context, AppRoutes.searchScreen);
                  },
                ),
              )
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  AppRoutes.navigateTo(context, AppRoutes.searchScreen);
                },
              ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid Categories
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: widget.categories.length,
                    itemBuilder: (context, index) {
                      final category = widget.categories[index];
                      return _shouldAnimate
                        ? FadeInUp(
                            duration: Duration(milliseconds: 400 + (index * 100)),
                            child: _buildCategoryCard(context, category),
                          )
                        : _buildCategoryCard(context, category);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryCard(BuildContext context, Category category) {
    return InkWell(
      onTap: () {
        AppRoutes.navigateTo(
          context,
          AppRoutes.allCategoryProductsScreen,
          arguments: {
            'category': category,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: CustomImage(
                imageUrl: category.banner ?? '',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholderAsset: AppImages.placeHolder,
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            // Text overlay
            Positioned(
              bottom: 16,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name?.toUpperCase() ?? '',
                    style: context.titleMedium!.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w700
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   '${category.productCount ?? 0} ${'items'.tr(context)}',
                  //   style: context.titleSmall!.copyWith(color: AppTheme.white),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}