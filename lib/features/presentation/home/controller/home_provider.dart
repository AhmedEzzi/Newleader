import 'package:flutter/material.dart';
import 'package:leader_company/core/services/widget_service.dart';
import 'package:leader_company/features/data/product/models/flash_deal_response_model.dart';
import 'package:leader_company/features/data/product/models/product_model.dart';
import 'package:leader_company/features/domain/product/entities/flash_deal.dart';
import 'package:leader_company/features/domain/product/usecases/get_all_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_featured_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_best_selling_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_new_added_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_todays_deal_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_flash_deal_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_category_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_sub_category_products_usecase.dart';
import 'package:leader_company/features/domain/product/usecases/get_brand_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_digital_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_related_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_shop_products_use_case.dart';
import 'package:leader_company/features/domain/product/usecases/get_top_from_this_seller_products_use_case.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/product/usecases/get_best_selling_products_use_case.dart';
import '../../../domain/product/usecases/get_featured_products_use_case.dart';
import '../../../domain/product/usecases/get_flash_deal_products_use_case.dart';
import '../../../domain/product/usecases/get_new_added_products_use_case.dart';
import '../../../domain/product/usecases/get_sub_category_products_usecase.dart';
import '../../../domain/product/usecases/get_todays_deal_products_use_case.dart';
import '../../../domain/product/usecases/get_category_products_use_case.dart';
import '../../../domain/product/usecases/get_brand_products_use_case.dart';
import '../../../domain/product/usecases/get_digital_products_use_case.dart';
import '../../../domain/product/usecases/get_related_products_use_case.dart';
import '../../../domain/product/usecases/get_shop_products_use_case.dart';
import '../../../domain/product/usecases/get_top_from_this_seller_products_use_case.dart';


class HomeProvider extends ChangeNotifier {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetBestSellingProductsUseCase getBestSellingProductsUseCase;
  final GetNewAddedProductsUseCase getNewAddedProductsUseCase;
  final GetTodaysDealProductsUseCase getTodaysDealProductsUseCase;
  final GetFlashDealProductsUseCase getFlashDealProductsUseCase;
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final GetSubCategoryProductsUseCase getSubCategoryProductsUseCase;
  final GetBrandProductsUseCase getBrandProductsUseCase;
  final GetDigitalProductsUseCase getDigitalProductsUseCase;
  final GetRelatedProductsUseCase getRelatedProductsUseCase;
  final GetShopProductsUseCase getShopProductsUseCase;
  final GetTopFromThisSellerProductsUseCase getTopFromThisSellerProductsUseCase;

  List<Product> allProducts = [];
  List<Product> featuredProducts = [];
  List<Product> bestSellingProducts = [];
  List<Product> newProducts = [];
  List<Product> todaysDealProducts = [];
  List<FlashDeal> flashDeals = [];
  List<Product> flashDealProducts = [];
  List<Product> categoryProducts = [];
  List<Product> subCategoryProducts = [];
  List<Product> brandProducts = [];
  List<Product> digitalProducts = [];
  List<Product> filteredProducts = [];
  Product? selectedProduct;
  List<Product> relatedProducts = [];
  List<Product> shopProducts = [];
  List<Product> topFromThisSellerProducts = [];
  dynamic variantInfo;

  int allProductsPage = 1;
  int featuredProductsPage = 1;
  int bestSellingProductsPage = 1;
  int newProductsPage = 1;
  bool hasMoreFeaturedProducts = true;
  bool hasMoreBestSellingProducts = true;
  bool hasMoreAllProducts = true;
  bool hasMoreNewProducts = true;
  int categoryProductsPage = 1;
  int subCategoryProductsPage = 1;
  int brandProductsPage = 1;
  int digitalProductsPage = 1;
  int filteredProductsPage = 1;
  int shopProductsPage = 1;
  bool hasMoreCategoryProducts = true;
  bool hasMoreSubCategoryProducts = true;
  bool hasMoreBrandProducts = true;
  bool hasMoreDigitalProducts = true;
  bool hasMoreFilteredProducts = true;
  bool hasMoreShopProducts = true;

  LoadingState allProductsState = LoadingState.loading;
  LoadingState featuredProductsState = LoadingState.loading;
  LoadingState bestSellingProductsState = LoadingState.loading;
  LoadingState newProductsState = LoadingState.loading;
  LoadingState todaysDealProductsState = LoadingState.loading;
  LoadingState flashDealProductsState = LoadingState.loading;
  LoadingState categoryProductsState = LoadingState.loading;
  LoadingState subCategoryProductsState = LoadingState.loading;
  LoadingState brandProductsState = LoadingState.loading;
  LoadingState digitalProductsState = LoadingState.loading;
  LoadingState filteredProductsState = LoadingState.loading;
  LoadingState relatedProductsState = LoadingState.loading;
  LoadingState shopProductsState = LoadingState.loading;
  LoadingState topFromThisSellerProductsState = LoadingState.loading;
  LoadingState variantInfoState = LoadingState.loading;

  String allProductsError = '';
  String featuredProductsError = '';
  String bestSellingProductsError = '';
  String newProductsError = '';
  String todaysDealProductsError = '';
  String flashDealProductsError = '';
  String categoryProductsError = '';
  String subCategoryProductsError = '';
  String brandProductsError = '';
  String digitalProductsError = '';
  String filteredProductsError = '';
  String relatedProductsError = '';
  String shopProductsError = '';
  String topFromThisSellerProductsError = '';
  String variantInfoError = '';

  HomeProvider({
    required this.getAllProductsUseCase,
    required this.getFeaturedProductsUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewAddedProductsUseCase,
    required this.getTodaysDealProductsUseCase,
    required this.getFlashDealProductsUseCase,
    required this.getCategoryProductsUseCase,
    required this.getBrandProductsUseCase,
    required this.getDigitalProductsUseCase,
    required this.getRelatedProductsUseCase,
    required this.getShopProductsUseCase,
    required this.getSubCategoryProductsUseCase,
    required this.getTopFromThisSellerProductsUseCase,
  });

  // Existing initialization method
  Future<void> initHomeData() async {
    await Future.wait([
      fetchAllProducts(),
      fetchFeaturedProducts(),
      fetchBestSellingProducts(),
      fetchNewProducts(),
      fetchTodaysDealProducts(),
      fetchFlashDealProducts(),
    ]);
  }

  void setInitialProducts(List<Product> products) {
    filteredProducts = products;
    filteredProductsState = LoadingState.loaded;
    hasMoreFilteredProducts = false;
    notifyListeners();
  }

// Modify the fetchAllProducts method in HomeProvider
  Future<void> fetchAllProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        allProductsPage = 1;
        hasMoreAllProducts = true;
        allProducts = [];
        print('PAGINATION_DEBUG: Reset allProductsPage to 1, hasMoreAllProducts=true');
      }

      if (!hasMoreAllProducts) {
        print('PAGINATION_DEBUG: hasMoreAllProducts is false, returning early');
        return;
      }

      allProductsState = LoadingState.loading;
      notifyListeners();

      print('PAGINATION_DEBUG: Fetching page $allProductsPage');
      final response = await getAllProductsUseCase(allProductsPage, needUpdate: refresh);

      // Log retrieved data
      print('PAGINATION_DEBUG: All Products Response: ${response.data.length} items');
      print('PAGINATION_DEBUG: Response meta - currentPage: ${response.meta.currentPage}, lastPage: ${response.meta.lastPage}, total: ${response.meta.total}');
      print('PAGINATION_DEBUG: Response links - next: ${response.links.next}');

      // Filter products at data source level if possible
      List<Product> newProducts = response.data;

      if (refresh) {
        allProducts = newProducts;
        print('PAGINATION_DEBUG: Refreshing, setting allProducts to ${newProducts.length} items');
      } else {
        allProducts.addAll(newProducts);
        print('PAGINATION_DEBUG: Adding ${newProducts.length} new items, total now: ${allProducts.length}');
      }

      // Check if we have more pages
      hasMoreAllProducts = response.meta.currentPage < response.meta.lastPage;
      print('PAGINATION_DEBUG: Setting hasMoreAllProducts to $hasMoreAllProducts (currentPage=${response.meta.currentPage}, lastPage=${response.meta.lastPage})');
      
      if (hasMoreAllProducts) {
        allProductsPage++;
        print('PAGINATION_DEBUG: Incrementing allProductsPage to $allProductsPage');
      }

      allProductsState = LoadingState.loaded;

      // If we don't have enough published products and there are more pages, fetch more
      if (allProducts.where((p) => p.published == 1).length < 8 && hasMoreAllProducts) {
        print('PAGINATION_DEBUG: Not enough published products, fetching more automatically');
        await fetchAllProducts();
      }
    } catch (e) {
      allProductsState = LoadingState.error;
      allProductsError = e.toString();
      print('PAGINATION_DEBUG: Error fetching all products: $e');
    } finally {
      notifyListeners();
    }
  }

  // Featured Products methods
  Future<void> fetchFeaturedProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        featuredProductsPage = 1;
        hasMoreFeaturedProducts = true;
        featuredProducts = [];
      }

      if (!hasMoreFeaturedProducts) return;

      featuredProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getFeaturedProductsUseCase(featuredProductsPage,needUpdate: refresh);

      if (refresh) {
        featuredProducts = response.data;
      } else {
        featuredProducts.addAll(response.data);
      }

      hasMoreFeaturedProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreFeaturedProducts) {
        featuredProductsPage++;
      }

      featuredProductsState = LoadingState.loaded;
    } catch (e) {
      featuredProductsState = LoadingState.error;
      featuredProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Best Selling Products methods
  Future<void> fetchBestSellingProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        bestSellingProductsPage = 1;
        hasMoreBestSellingProducts = true;
        bestSellingProducts = [];
      }

      if (!hasMoreBestSellingProducts) return;

      bestSellingProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getBestSellingProductsUseCase(
          bestSellingProductsPage,needUpdate: refresh
      );

      if (refresh) {
        bestSellingProducts = response.data;
      } else {
        bestSellingProducts.addAll(response.data);
      }

      hasMoreBestSellingProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreBestSellingProducts) {
        bestSellingProductsPage++;
      }

      bestSellingProductsState = LoadingState.loaded;
      
      // Update widget data with best selling products
      if (bestSellingProducts.isNotEmpty) {
        await WidgetService().updateWidgetDataFromProvider(this);
      }
    } catch (e) {
      bestSellingProductsState = LoadingState.error;
      bestSellingProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New Products methods
  Future<void> fetchNewProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        newProductsPage = 1;
        hasMoreNewProducts = true;
        newProducts = [];
      }

      if (!hasMoreNewProducts) return;

      newProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getNewAddedProductsUseCase(newProductsPage,needUpdate: refresh);

      if (refresh) {
        newProducts = response.data;
      } else {
        newProducts.addAll(response.data);
      }

      hasMoreNewProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreNewProducts) {
        newProductsPage++;
      }

      newProductsState = LoadingState.loaded;
    } catch (e) {
      newProductsState = LoadingState.error;
      newProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Today's Deal Products methods
  Future<void> fetchTodaysDealProducts({bool refresh = false}) async {
    try {
      todaysDealProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getTodaysDealProductsUseCase(needUpdate: refresh);
      todaysDealProducts = response.data;

      todaysDealProductsState = LoadingState.loaded;
    } catch (e) {
      todaysDealProductsState = LoadingState.error;
      todaysDealProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Updated Flash Deal Products method to handle the new structure
  Future<void> fetchFlashDealProducts({bool refresh = false}) async {
    try {
      flashDealProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getFlashDealProductsUseCase(needUpdate: refresh);


      flashDeals = response.data;

      final allProducts = <Product>[];
      for (final deal in response.data) {
        allProducts.addAll(deal.products);
      }
      flashDealProducts = allProducts;


      flashDealProductsState = LoadingState.loaded;
      notifyListeners();
      return;

    } catch (e) {
      flashDealProductsState = LoadingState.error;
      flashDealProductsError = e.toString();
      debugPrint('Error fetching flash deal products: $e');
      
      flashDeals = [];
      flashDealProducts = [];
    } finally {
      notifyListeners();
    }
  }

  // New method for Category Products
  Future<void> fetchCategoryProducts(
      int categoryId, {
        bool refresh = false,
        String? name,
      }) async {
    try {
      if (refresh) {
        categoryProductsPage = 1;
        hasMoreCategoryProducts = true;
        categoryProducts = [];
      }

      if (!hasMoreCategoryProducts) return;

      categoryProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getCategoryProductsUseCase(
          categoryId,
          categoryProductsPage,
          name: name,needUpdate: refresh
      );

      if (refresh) {
        categoryProducts = response.data;
      } else {
        categoryProducts.addAll(response.data);
      }

      hasMoreCategoryProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreCategoryProducts) {
        categoryProductsPage++;
      }

      categoryProductsState = LoadingState.loaded;
    } catch (e) {
      categoryProductsState = LoadingState.error;
      categoryProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for SubCategory Products
  Future<void> fetchSubCategoryProducts(
      int subCategoryId, {
        bool refresh = false,
        String? name,
      }) async {
    try {
      if (refresh) {
        subCategoryProductsPage = 1;
        hasMoreSubCategoryProducts = true;
        subCategoryProducts = [];
      }

      if (!hasMoreSubCategoryProducts) return;

      subCategoryProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getSubCategoryProductsUseCase(
          subCategoryId,
          subCategoryProductsPage,
          name: name,needUpdate: refresh
      );

      if (refresh) {
        subCategoryProducts = response.data;
      } else {
        subCategoryProducts.addAll(response.data);
      }

      hasMoreSubCategoryProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreSubCategoryProducts) {
        subCategoryProductsPage++;
      }

      subCategoryProductsState = LoadingState.loaded;
    } catch (e) {
      subCategoryProductsState = LoadingState.error;
      subCategoryProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Brand Products
  Future<void> fetchBrandProducts(
      String slug, {
        bool refresh = false,
        String? name,
      }) async {
    try {
      if (refresh) {
        brandProductsPage = 1;
        hasMoreBrandProducts = true;
        brandProducts = [];
      }

      if (!hasMoreBrandProducts) return;

      brandProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getBrandProductsUseCase(
          slug,
          brandProductsPage,
          name: name,needUpdate: refresh
      );

      if (refresh) {
        brandProducts = response.data;
      } else {
        brandProducts.addAll(response.data);
      }

      hasMoreBrandProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreBrandProducts) {
        brandProductsPage++;
      }

      brandProductsState = LoadingState.loaded;
    } catch (e) {
      brandProductsState = LoadingState.error;
      brandProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Digital Products
  Future<void> fetchDigitalProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        digitalProductsPage = 1;
        hasMoreDigitalProducts = true;
        digitalProducts = [];
      }

      if (!hasMoreDigitalProducts) return;

      digitalProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getDigitalProductsUseCase(digitalProductsPage,needUpdate: refresh);

      if (refresh) {
        digitalProducts = response.data;
      } else {
        digitalProducts.addAll(response.data);
      }

      hasMoreDigitalProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreDigitalProducts) {
        digitalProductsPage++;
      }

      digitalProductsState = LoadingState.loaded;
    } catch (e) {
      digitalProductsState = LoadingState.error;
      digitalProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }



  // New method for Related Products
  Future<void> fetchRelatedProducts(int productId,{bool refresh = false}) async {
    try {
      relatedProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getRelatedProductsUseCase(productId,needUpdate: refresh);
      relatedProducts = response.data;

      relatedProductsState = LoadingState.loaded;
    } catch (e) {
      relatedProductsState = LoadingState.error;
      relatedProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Shop Products
  Future<void> fetchShopProducts(
      int shopId, {
        bool refresh = false,
        String? name,
      }) async {
    try {
      if (refresh) {
        shopProductsPage = 1;
        hasMoreShopProducts = true;
        shopProducts = [];
      }

      if (!hasMoreShopProducts) return;

      shopProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getShopProductsUseCase(
          shopId,
          shopProductsPage,
          name: name,needUpdate: refresh
      );

      if (refresh) {
        shopProducts = response.data;
      } else {
        shopProducts.addAll(response.data);
      }

      hasMoreShopProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreShopProducts) {
        shopProductsPage++;
      }

      shopProductsState = LoadingState.loaded;
    } catch (e) {
      shopProductsState = LoadingState.error;
      shopProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Top From This Seller Products
  Future<void> fetchTopFromThisSellerProducts(int sellerId,{bool refresh = false}) async {
    try {
      topFromThisSellerProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getTopFromThisSellerProductsUseCase(sellerId,needUpdate: refresh);
      topFromThisSellerProducts = response.data;

      topFromThisSellerProductsState = LoadingState.loaded;
    } catch (e) {
      topFromThisSellerProductsState = LoadingState.error;
      topFromThisSellerProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }


  // Update the refresh method to include all refreshable sections
  Future<void> refreshHomeData() async {
    // Reset all states to loading
    allProductsState = LoadingState.loading;
    featuredProductsState = LoadingState.loading;
    bestSellingProductsState = LoadingState.loading;
    newProductsState = LoadingState.loading;
    todaysDealProductsState = LoadingState.loading;
    flashDealProductsState = LoadingState.loading;
    notifyListeners();
    
    // Refresh all data with refresh flag set to true
    await Future.wait([
      fetchAllProducts(refresh: true),
      fetchFeaturedProducts(refresh: true),
      fetchBestSellingProducts(refresh: true),
      fetchNewProducts(refresh: true),
      fetchTodaysDealProducts(refresh: true),
      fetchFlashDealProducts(refresh: true),
      fetchDigitalProducts(refresh: true),
    ]);
    
    // Notify about completed refresh
    notifyListeners();
  }

  // Updated helper to check if any section is loading
  bool get isAnyLoading {
    return allProductsState == LoadingState.loading ||
        featuredProductsState == LoadingState.loading ||
        bestSellingProductsState == LoadingState.loading ||
        newProductsState == LoadingState.loading ||
        todaysDealProductsState == LoadingState.loading ||
        flashDealProductsState == LoadingState.loading ||
        categoryProductsState == LoadingState.loading ||
        brandProductsState == LoadingState.loading ||
        digitalProductsState == LoadingState.loading ||
        filteredProductsState == LoadingState.loading ||
        relatedProductsState == LoadingState.loading ||
        shopProductsState == LoadingState.loading ||
        topFromThisSellerProductsState == LoadingState.loading ||
        variantInfoState == LoadingState.loading;
  }

  // Updated helper to check if main sections are loaded
  bool get isAllLoaded {
    return allProductsState == LoadingState.loaded &&
        featuredProductsState == LoadingState.loaded &&
        bestSellingProductsState == LoadingState.loaded &&
        newProductsState == LoadingState.loaded &&
        todaysDealProductsState == LoadingState.loaded &&
        flashDealProductsState == LoadingState.loaded;
  }

  // Special method for language change - resets all cache and forces refresh
  Future<void> refreshAfterLanguageChange() async {
    debugPrint('Refreshing all home data after language change');
    
    // Reset all states to loading
    allProductsState = LoadingState.loading;
    featuredProductsState = LoadingState.loading;
    bestSellingProductsState = LoadingState.loading;
    newProductsState = LoadingState.loading;
    todaysDealProductsState = LoadingState.loading;
    flashDealProductsState = LoadingState.loading;
    notifyListeners();
    
    // Reset all pages
    allProductsPage = 1;
    featuredProductsPage = 1;
    bestSellingProductsPage = 1;
    newProductsPage = 1;
    
    // Reset hasMore flags
    hasMoreAllProducts = true;
    hasMoreFeaturedProducts = true;
    hasMoreBestSellingProducts = true;
    hasMoreNewProducts = true;
    
    // Force refresh all data with needUpdate flag set to true
    await Future.wait([
      fetchAllProducts(refresh: true),
      fetchFeaturedProducts(refresh: true),
      fetchBestSellingProducts(refresh: true),
      fetchNewProducts(refresh: true),
      fetchTodaysDealProducts(refresh: true),
      fetchDigitalProducts(refresh: true),
      fetchFlashDealProducts(refresh: true),
    ]);
    
    notifyListeners();
  }
}
