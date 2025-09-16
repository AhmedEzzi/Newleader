import 'package:flutter/material.dart';
import '../../../domain/brand/entities/brand.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/brand/usecases/get_brands_usecases.dart';
import '../../../domain/brand/usecases/get_filter_brands_usecases.dart';
import '../../../domain/brand/usecases/get_total_brands_pages_usecases.dart';

class BrandProvider extends ChangeNotifier {
  final GetFilterPageBrandsUseCase getFilterPageBrandsUseCase;
  final GetBrandsUseCase getBrandsUseCase;
  final GetTotalBrandPagesUseCase getTotalBrandPagesUseCase;

  BrandProvider({
    required this.getFilterPageBrandsUseCase,
    required this.getBrandsUseCase,
    required this.getTotalBrandPagesUseCase,
  });

  LoadingState brandState = LoadingState.loading;
  List<Brand> filterBrands = [];
  List<Brand> brands = [];
  int currentPage = 1;
  int totalPages = 1;
  String brandError = '';

  Future<void> fetchFilterPageBrands() async {
    try {
      brandState = LoadingState.loading;
      notifyListeners();

      filterBrands = await getFilterPageBrandsUseCase();
      brandState = LoadingState.loaded;
    } catch (e) {
      brandState = LoadingState.error;
      brandError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchBrands({String name = '', bool loadMore = false}) async {
    try {
      if (!loadMore) {
        brandState = LoadingState.loading;
        currentPage = 1;
      } else if (currentPage >= totalPages) {
        return;
      } else {
        currentPage++;
      }
      notifyListeners();

      final newBrands = await getBrandsUseCase(name: name, page: currentPage);
      totalPages = await getTotalBrandPagesUseCase(name: name);

      if (!loadMore) {
        brands = newBrands;
      } else {
        brands.addAll(newBrands);
      }
      brandState = LoadingState.loaded;
    } catch (e) {
      brandState = LoadingState.error;
      brandError = e.toString();
    } finally {
      notifyListeners();
    }
  }
}