import 'package:flutter/material.dart';
import 'package:leader_company/features/domain/product%20details/entities/product_details.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/product details/entities/variant_product_price.dart';
import '../../../domain/product details/usecases/get_product_details_use_case.dart';
import '../../../domain/product details/usecases/get_variant_price_use_case.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetVariantPriceUseCase getVariantPriceUseCase;

  ProductDetailsProvider({
    required this.getProductDetailsUseCase,
    required this.getVariantPriceUseCase,
  });

  // Product details state
  LoadingState productDetailsState = LoadingState.loading;
  ProductDetails? selectedProduct;
  String productDetailsError = '';

  // Variant price state
  LoadingState variantPriceState = LoadingState.initial;
  VariantPrice? variantPrice;
  String variantPriceError = '';

  // Selected variations
  String? selectedColor;
  Map<String, String> selectedVariants = {};
  int quantity = 1;

  // Track current displayed photo index
  int currentPhotoIndex = 0;

  // Cart operation state
  bool isAddingToCart = false;

  // Reset all state when navigating to a new product
  void resetState() {
    selectedColor = null;
    selectedVariants = {};
    quantity = 1;
    variantPrice = null;
    isAddingToCart = false;
    currentPhotoIndex = 0;
    // Don't reset selectedProduct to avoid flickering during navigation
    notifyListeners();
  }

  Future<void> fetchProductDetails(String slug) async {
    try {
      // First reset all state to avoid stale data
      resetState();

      productDetailsState = LoadingState.loading;
      notifyListeners();

      final product = await getProductDetailsUseCase(slug);
      selectedProduct = product;

      // Initialize selected color if colors available
      if (product.colors.isNotEmpty) {
        selectedColor = product.colors.first.replaceAll('#', '');
      }

      // Initialize choice options if available
      selectedVariants = {};
      if (product.choiceOptions.isNotEmpty) {
        for (final option in product.choiceOptions) {
          if (option.options.isNotEmpty) {
            selectedVariants[option.name] = option.options.first;
          }
        }
      }

      productDetailsState = LoadingState.loaded;

      // Only fetch variant price if the product has variations
      if (product.hasVariation) {
        await _updateVariantPrice();
      }
    } catch (e) {
      productDetailsState = LoadingState.error;
      productDetailsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void setSelectedColor(String color) {
    selectedColor = color.replaceAll('#', '');
    _updateVariantPrice();
    notifyListeners();
  }

  void setVariantOption(String name, String value) {
    selectedVariants[name] = value;
    _updateVariantPrice();
    notifyListeners();
  }

  void setQuantity(int value) {
    // Make sure quantity is always at least 1
    quantity = value < 1 ? 1 : value;

    // Optionally limit to available stock if variant price is available
    if (variantPrice != null && quantity > variantPrice!.data.stock) {
      quantity = variantPrice!.data.stock;
    }

    _updateVariantPrice();
    notifyListeners();
  }

  String get variantsString {
    if (selectedVariants.isEmpty) return '';
    return selectedVariants.values.join(',');
  }

  bool get canAddToCart {
    if (selectedProduct == null) return false;

    // Check if product is in stock
    if (selectedProduct!.hasVariation) {
      return variantPrice != null && variantPrice!.data.stock > 0;
    } else {
      return selectedProduct!.currentStock > 0;
    }
  }

  // Find the index of photo that matches variant
  int findVariantPhotoIndex() {
    if (selectedProduct == null || variantPrice == null) return currentPhotoIndex;

    final variant = variantPrice!.data.variant;
    if (variant.isEmpty) return currentPhotoIndex;

    // Look for photos with matching variant in the photo array
    for (int i = 0; i < selectedProduct!.photos.length; i++) {
      if (selectedProduct!.photos[i].variant == variant) {
        return i;
      }
    }

    // If no matching variant photo found, try to match by color
    if (selectedColor != null && selectedColor!.isNotEmpty) {
      for (int i = 0; i < selectedProduct!.photos.length; i++) {
        if (selectedProduct!.photos[i].variant == selectedColor) {
          return i;
        }
      }
    }

    // If no match found, keep current photo
    return currentPhotoIndex;
  }

  void updatePhotoForVariant() {
    int newIndex = findVariantPhotoIndex();
    if (newIndex != currentPhotoIndex) {
      currentPhotoIndex = newIndex;
      notifyListeners();
    }
  }

  Future<void> _updateVariantPrice() async {
    if (selectedProduct == null || !selectedProduct!.hasVariation) return;

    try {
      await fetchVariantPrice(
        selectedProduct!.slug,
        selectedColor ?? '',
        variantsString,
        quantity,
      );

      // After price update, check for matching variant image
      updatePhotoForVariant();
    } catch (e) {
      print('Error updating variant price: $e');
    }
  }

  Future<void> fetchVariantPrice(
      String slug,
      String color,
      String variants,
      int quantity,
      ) async {
    try {
      variantPriceState = LoadingState.loading;
      notifyListeners();

      final result = await getVariantPriceUseCase(
        slug,
        color,
        variants,
        quantity,
      );
      variantPrice = result;

      variantPriceState = LoadingState.loaded;
    } catch (e) {
      variantPriceState = LoadingState.error;
      variantPriceError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Helper method to set adding to cart state
  void setAddingToCartState(bool isAdding) {
    isAddingToCart = isAdding;
    notifyListeners();
  }
}