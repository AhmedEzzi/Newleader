import '../../../data/category/models/category_model.dart';
import '../repositories/category_repository.dart';

class GetFeaturedCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetFeaturedCategoriesUseCase(this.categoryRepository);

  Future<CategoryResponseModel> call({bool needRefresh = false}) async {
    return await categoryRepository.getFeaturedCategories(needRefresh: needRefresh);
  }
}