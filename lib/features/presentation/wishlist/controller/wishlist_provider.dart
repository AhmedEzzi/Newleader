import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/wishlist/entities/wishlist_details.dart';
import '../../../domain/wishlist/usecases/add_wishlist_usecases.dart';
import '../../../domain/wishlist/usecases/check_wishlist_usecases.dart';
import '../../../domain/wishlist/usecases/get_wishlist_usecases.dart';
import '../../../domain/wishlist/usecases/remove_wishlist_usecases.dart';

class WishlistProvider extends ChangeNotifier {
  final GetWishlistUseCase getWishlistUseCase;
  final CheckWishlistUseCase checkWishlistUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;

  WishlistProvider({
    required this.getWishlistUseCase,
    required this.checkWishlistUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  });

  LoadingState wishlistState = LoadingState.loading;
  List<WishlistItem> wishlistItems = [];
  String wishlistError = '';

  // Map for tracking wishlist status - product slug to boolean (in wishlist or not)
  Map<String, bool> wishlistStatus = {};

  // Set of product slugs in wishlist for quick lookup
  Set<String> _wishlistSlugs = {};

  // Flag to track initial loading state - we only show shimmer on initial load
  bool _initialLoadComplete = false;

  String? lastActionMessage;

  // Check if a product is in wishlist using the Set
  bool isProductInWishlist(String slug) {
    return _wishlistSlugs.contains(slug);
  }

  Future<void> fetchWishlist({bool showLoading = true}) async {
    try {
      // Only show loading state if explicitly requested and initial load is not done
      if (showLoading && !_initialLoadComplete) {
      wishlistState = LoadingState.loading;
      notifyListeners();
      }

      final items = await getWishlistUseCase();

      wishlistItems = items;
      _updateWishlistTracking();

      wishlistState = LoadingState.loaded;
      _initialLoadComplete = true;
    } catch (e) {
      // Only update state to error if we were showing loading
      if (showLoading && !_initialLoadComplete) {
      wishlistState = LoadingState.error;
      }
      wishlistError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Helper method to update tracking data structures
  void _updateWishlistTracking() {
    // Clear and repopulate tracking structures
    wishlistStatus.clear();
    _wishlistSlugs.clear();

    // Update based on current wishlist items
    for (var item in wishlistItems) {
      wishlistStatus[item.slug] = true;
      _wishlistSlugs.add(item.slug);
    }
  }

  Future<bool> isInWishlist(String slug) async {
    // First check local tracking for quick response
    if (wishlistStatus.containsKey(slug)) {
      return wishlistStatus[slug] ?? false;
    }

    if (_wishlistSlugs.contains(slug)) {
      return true;
    }

    // If not in local tracking, check with backend
    try {
      final check = await checkWishlistUseCase(slug);

      // Update both tracking systems
      wishlistStatus[slug] = check.isInWishlist;
      if (check.isInWishlist) {
        _wishlistSlugs.add(slug);
      }

      notifyListeners();
      return check.isInWishlist;
    } catch (e) {
      wishlistError = e.toString();
      return false;
    }
  }

  Future<void> addToWishlist(String slug) async {
    // Optimistically add to local list
    WishlistItem tempItem = WishlistItem(
      id: 0, // Temp ID will be replaced when syncing with backend
      slug: slug,
      name: "Loading...", // Will be updated after sync
      price: "0",  // Changed from int to String
      thumbnailImage: "",
      hasVariation: false,
      productId: 0,
      currencySymbol: "", // Added required parameter
      rating: 0,
      ratingCount: 0,
    );
    
    // Add to local list first for immediate UI update
    wishlistItems.add(tempItem);
    _wishlistSlugs.add(slug);
    wishlistStatus[slug] = true;
    notifyListeners();
    
    try {
      // Perform API call in background
      final result = await addToWishlistUseCase(slug);
      lastActionMessage = result.message;

      // Update with server data without showing shimmer
      await fetchWishlist(showLoading: false);
    } catch (e) {
      // If API call fails, revert the local change
      wishlistItems.removeWhere((item) => item.slug == slug);
      _wishlistSlugs.remove(slug);
      wishlistStatus[slug] = false;
      
      wishlistError = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String slug) async {
    // Optimistically remove from local list
    wishlistItems.removeWhere((item) => item.slug == slug);
    _wishlistSlugs.remove(slug);
    wishlistStatus[slug] = false;
    
    // Notify immediately for responsive UI
    notifyListeners();
    
    try {
      // Perform API call in background
      final result = await removeFromWishlistUseCase(slug);
      lastActionMessage = result.message;

      // No need to refresh list - item is already removed locally
    } catch (e) {
      // If API call fails, we should add the item back
      // But we need full item data, so we'll refresh from server
      wishlistError = e.toString();
      await fetchWishlist(showLoading: false);
    }
  }

  // Method to clear the entire wishlist
  Future<void> clearWishlist() async {
    // Store items for potential recovery
    final backupItems = List<WishlistItem>.from(wishlistItems);

    // Clear local list immediately
    wishlistItems.clear();
      wishlistStatus.clear();
      _wishlistSlugs.clear();
    notifyListeners();
    
    try {
      // Process each item on the server side
      for (var item in backupItems) {
        await removeFromWishlistUseCase(item.slug);
      }

      lastActionMessage = "Wishlist cleared successfully";
    } catch (e) {
      // On failure, restore backup and fetch fresh data
      wishlistError = e.toString();
      await fetchWishlist(showLoading: false);
    }
  }

  // Toggle wishlist status - convenience method
  Future<void> toggleWishlistStatus(BuildContext context, String slug) async {
    // Check current status and toggle
    bool currentStatus = _wishlistSlugs.contains(slug);

    if (currentStatus) {
      await removeFromWishlist(slug);
    } else {
      await addToWishlist(slug);
    }
  }
}