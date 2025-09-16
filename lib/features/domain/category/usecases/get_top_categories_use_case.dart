import '../../../data/category/models/category_model.dart';
import '../repositories/category_repository.dart';

class GetTopCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetTopCategoriesUseCase(this.categoryRepository);

  Future<CategoryResponseModel> call({bool needRefresh = false}) async {
    return await categoryRepository.getTopCategories(needRefresh: needRefresh);
  }
}