import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/enums/loading_state.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import 'package:leader_company/features/presentation/all%20products/widgets/shimmer/category_list_shimmer.dart';
import 'package:leader_company/features/presentation/category/controller/provider.dart';

class CategoryList extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final int selectedCategoryId;
  final Function(String name, int id) onSelectCategory;

  const CategoryList({
    Key? key,
    required this.categoryProvider,
    required this.selectedCategoryId,
    required this.onSelectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryProvider.filterPageCategoriesState == LoadingState.loading) {
      return const CategoryListShimmer();
    }

    if (categoryProvider.filterPageCategoriesState == LoadingState.error) {
      return SizedBox(
        height: 50,
        child: Center(child: Text('Error: ${categoryProvider.errorMessage}'.tr(context))),
      );
    }

    final categories = categoryProvider.filterPageCategoriesResponse?.data
        .map((c) => {'name': c.name, 'id': c.id})
        .toList() ??
        [];

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['id'] == selectedCategoryId;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Material(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: isSelected ? 4 : 1,
              child: InkWell(
                onTap: () => onSelectCategory(
                  category['name'] as String,
                  category['id'] as int,
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Center(
                    child: Text(
                      category['name'] as String,
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