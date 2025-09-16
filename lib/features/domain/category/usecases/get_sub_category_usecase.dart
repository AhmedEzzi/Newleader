import '../../../data/category/models/category_model.dart';
import '../repositories/category_repository.dart';

class GetSubCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetSubCategoriesUseCase(this.categoryRepository);

  Future<CategoryResponseModel> call({required String mainCategoryId, bool needRefresh = false}) async {
    return await categoryRepository.getSubCategories(
        mainCategoryId: mainCategoryId,
        needRefresh: needRefresh
    );
  }
}