import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/features/presentation/all%20products/widgets/shimmer/subcategory_list_shimmer.dart';
import 'package:leader_company/features/presentation/category/controller/provider.dart';

class SubCategoryList extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final int? selectedSubCategoryId;
  final Function(String name, int id) onSelectSubCategory;

  const SubCategoryList({
    super.key,
    required this.categoryProvider,
    required this.selectedSubCategoryId,
    required this.onSelectSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryProvider.subCategoriesState == LoadingState.loading) {
      return const SubCategoryListShimmer();
    }

    if (categoryProvider.subCategoriesState == LoadingState.error) {
      return SizedBox(
        height: 50,
        child: Center(child: Text('Error: ${categoryProvider.errorMessage}'.tr(context))),
      );
    }

    final subCategories = categoryProvider.subCategoriesResponse?.data
        .map((c) => {'name': c.name, 'id': c.id})
        .toList() ??
        [];

    if (subCategories.isEmpty) {
      return const SizedBox(height: 10);
    }

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subCategories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          final isSelected = subCategory['id'] == selectedSubCategoryId;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Material(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: isSelected ? 4 : 1,
              child: InkWell(
                onTap: () => onSelectSubCategory(
                  subCategory['name'] as String,
                  subCategory['id'] as int,
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Center(
                    child: Text(
                      subCategory['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}