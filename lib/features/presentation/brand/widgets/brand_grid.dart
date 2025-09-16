import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import '../../../domain/brand/entities/brand.dart';
import '../../../../core/utils/widgets/custom_loading.dart';
import 'brand_item.dart';

class BrandGrid extends StatelessWidget {
  final List<Brand> brands;
  final bool isLoadingMore;

  const BrandGrid({
    super.key,
    required this.brands,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            'no_brands_found'.tr(context),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          // Show loader at the end when loading more
          if (index == brands.length && isLoadingMore) {
            return const Center(child: CustomLoadingWidget());
          }

          if (index < brands.length) {
            return BrandItem(brand: brands[index]);
          }

          return null;
        },
        childCount: brands.length + (isLoadingMore ? 1 : 0),
      ),
    );
  }
}