import 'package:flutter/material.dart';
import '../../../domain/cart/entities/cart.dart';
import '../../../domain/cart/entities/shipping_update_response.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/cart/usecases/add_to_cart_usecases.dart';
import '../../../domain/cart/usecases/clear_cart_usecases.dart';
import '../../../domain/cart/usecases/delete_cart_item_usecases.dart';
import '../../../domain/cart/usecases/get_cart_count_usecases.dart';
import '../../../domain/cart/usecases/get_cart_items_usecases.dart';
import '../../../domain/cart/usecases/get_cart_summary_usecases.dart';
import '../../../domain/cart/usecases/update_cart_quantities_usecases.dart';

class CartProvider extends ChangeNotifier {
  final GetCartItemsUseCase getCartItemsUseCase;
  final GetCartCountUseCase getCartCountUseCase;
  final DeleteCartItemUseCase deleteCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;
  final UpdateCartQuantitiesUseCase updateCartQuantitiesUseCase;
  final AddToCartUseCase addToCartUseCase;
  final GetCartSummaryUseCase getCartSummaryUseCase;

  CartProvider({
    required this.getCartItemsUseCase,
    required this.getCartCountUseCase,
    required this.deleteCartItemUseCase,
    required this.clearCartUseCase,
    required this.updateCartQuantitiesUseCase,
    required this.addToCartUseCase,
    required this.getCartSummaryUseCase,
  });

  // Cart items state
  LoadingState cartState = LoadingState.loading;
  List<CartItem> cartItems = [];
  int cartCount = 0;
  String cartError = '';
  bool _initialLoadComplete = false;
  
  // Track items being updated (quantity)
  Set<int> _itemsUpdatingQuantity = {};
  // Maps item ID to the operation (true for decrement, false for increment)
  Map<int, bool> _itemUpdateOperation = {};
  
  bool isItemQuantityUpdating(int itemId) => _itemsUpdatingQuantity.contains(itemId);
  bool isDecrementOperation(int itemId) => _itemUpdateOperation[itemId] == true;
  bool isIncrementOperation(int itemId) => _itemUpdateOperation[itemId] == false;
  
  // Helper to check if specific operation is being updated
  bool isSpecificOperationUpdating(int itemId, bool isDecrement) {
    return isItemQuantityUpdating(itemId) && 
           _itemUpdateOperation.containsKey(itemId) &&
           _itemUpdateOperation[itemId] == isDecrement;
  }
  
  // Synchronization tracking
  DateTime _lastSyncTime = DateTime.now();
  bool _needsFullSync = false;
  Duration _syncThreshold = const Duration(minutes: 2);
  
  // Offline mode tracking
  bool _isOfflineMode = false;
  bool _hasLocalData = false;
  int _failedNetworkAttempts = 0;
  
  // Cart summary state (separate from cart items)
  LoadingState summaryState = LoadingState.loading;
  CartSummary? cartSummary;
  String summaryError = '';
  
  ShippingUpdateResponse? shippingUpdateResponse;
  bool isUpdatingShipping = false;
  bool lastAddToCartSuccess = false;
  
  // Getters to expose offline state to UI
  bool get isOfflineMode => _isOfflineMode;
  bool get hasLocalData => _hasLocalData;

  // Initialize local cart count
  void _updateLocalCartCount() {
    cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
    notifyListeners();
  }
  
  // Check if we need to sync with server based on time threshold or force flag
  bool _shouldSyncWithServer({bool force = false}) {
    if (force || _needsFullSync) return true;
    final now = DateTime.now();
    return now.difference(_lastSyncTime) > _syncThreshold;
  }
  
  // Reset sync status after successful sync
  void _markAsSynced() {
    _lastSyncTime = DateTime.now();
    _needsFullSync = false;
    _failedNetworkAttempts = 0;
    _isOfflineMode = false;
  }
  
  // Force a full refresh of cart data while preserving UI state
  Future<void> forceRefresh() async {
    _needsFullSync = true;
    await syncCartWithServer(showLoadingUI: true);
  }
  
  // Enter offline mode when network is unavailable
  void _enterOfflineMode() {
    _isOfflineMode = true;
    _failedNetworkAttempts = 0; // Reset counter after entering offline mode
    _hasLocalData = cartItems.isNotEmpty || cartSummary != null;
    notifyListeners();
  }
  
  // Sync local cart with server data
  Future<void> syncCartWithServer({bool showLoadingUI = false}) async {
    if (!_shouldSyncWithServer() && !showLoadingUI) return;
    
    try {
      // Use loading state only if explicitly requested
      if (showLoadingUI) {
        cartState = LoadingState.loading;
        notifyListeners();
      }

      // Get cart items from server
      final serverItems = await getCartItemsUseCase();
      
      // Update local cart
      cartItems = serverItems;
      _updateLocalCartCount();
      
      // Load cart summary too
      await fetchCartSummary();
      
      cartState = LoadingState.loaded;
      _markAsSynced();
      _initialLoadComplete = true;
      _hasLocalData = cartItems.isNotEmpty || cartSummary != null;
    } catch (e) {
      if (showLoadingUI) {
        cartState = LoadingState.error;
      }
      cartError = e.toString();
      _needsFullSync = true; // Mark for retry on next operation
      
      // Handle offline mode transition
      _failedNetworkAttempts++;
      if (_failedNetworkAttempts >= 2 && !_isOfflineMode) {
        _enterOfflineMode();
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartItems({bool showLoading = true}) async {
    try {
      // Only show loading state if explicitly requested and initial load is not done
      if (showLoading && !_initialLoadComplete) {
        cartState = LoadingState.loading;
        notifyListeners();
      }

      final items = await getCartItemsUseCase();
      
      cartItems = items;
      _updateLocalCartCount();
      
      cartState = LoadingState.loaded;
      _initialLoadComplete = true;
      _markAsSynced(); // Mark sync time after fresh fetch
      _hasLocalData = cartItems.isNotEmpty;
    } catch (e) {
      // Only update state to error if we were showing loading
      if (showLoading && !_initialLoadComplete) {
        cartState = LoadingState.error;
      }
      cartError = e.toString();
      _needsFullSync = true;
      
      // Handle offline mode transition
      _failedNetworkAttempts++;
      if (_failedNetworkAttempts >= 2 && !_isOfflineMode && cartItems.isNotEmpty) {
        _enterOfflineMode();
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartSummary() async {
    try {
      summaryState = LoadingState.loading;
      notifyListeners();
      
      cartSummary = await getCartSummaryUseCase();
      
      summaryState = LoadingState.loaded;
      _hasLocalData = cartSummary != null;
    } catch (e) {
      summaryState = LoadingState.error;
      summaryError = e.toString();
      
      // Handle offline mode
      _failedNetworkAttempts++;
      if (_failedNetworkAttempts >= 2 && !_isOfflineMode && cartSummary != null) {
        _enterOfflineMode();
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartCount() async {
    try {
      // Use server count as a fallback/verification 
      final serverCount = await getCartCountUseCase();
      
      // If counts don't match, we might have desync - schedule a full sync
      if (serverCount != cartCount) {
        _needsFullSync = true;
        syncCartWithServer();
      }
      
      cartCount = serverCount;
      _failedNetworkAttempts = 0; // Reset counter on successful network call
      notifyListeners();
    } catch (e) {
      cartError = e.toString();
      // If server fetch fails, rely on local count
      _updateLocalCartCount();
      
      // Handle offline mode
      _failedNetworkAttempts++;
      if (_failedNetworkAttempts >= 2 && !_isOfflineMode) {
        _enterOfflineMode();
      }
    }
  }

  // Try to exit offline mode by attempting to sync with server
  Future<bool> tryReconnect() async {
    try {
      await fetchCartItems(showLoading: false);
      await fetchCartSummary();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Optimized cart item deletion to avoid UI jumps
  Future<void> deleteCartItem(int cartId) async {
    try {
      // Store the current cart items
      final List<CartItem> currentItems = [...cartItems];
      
      // First, optimistically remove the item locally for immediate UI feedback
      cartItems = currentItems.where((item) => item.id != cartId).toList();
      _updateLocalCartCount();
      notifyListeners();

      // Then perform the actual server deletion
      await deleteCartItemUseCase(cartId);
      
      // Finally refresh everything to make sure we're in sync
      await Future.wait([
        fetchCartItems(showLoading: false),
        fetchCartSummary(),
      ]);
    } catch (e) {
      cartError = e.toString();
      // If there was an error, re-fetch the cart items to restore correct state
      await fetchCartItems();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      await clearCartUseCase();
      await fetchCartItems();
      await fetchCartCount();
      notifyListeners();
    } catch (e) {
      cartError = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateCartQuantities(String cartIds, String quantities, {bool isDecrement = false}) async {
    try {
      // Parse cart IDs to determine which items are being updated
      final List<int> updatingIds = cartIds.split(',')
          .map((idStr) => int.tryParse(idStr.trim()))
          .whereType<int>()
          .toList();
      
      // Mark items as updating and record the operation type
      _itemsUpdatingQuantity.addAll(updatingIds);
      
      // Set operation type for each item being updated
      for (final id in updatingIds) {
        _itemUpdateOperation[id] = isDecrement;
      }
      
      notifyListeners();
      
      await updateCartQuantitiesUseCase(cartIds, quantities);
      await fetchCartItems(showLoading: false);
      await fetchCartCount();
      await fetchCartSummary();
    } catch (e) {
      cartError = e.toString();
    } finally {
      // Clear updating status
      _itemsUpdatingQuantity.clear();
      _itemUpdateOperation.clear();
      notifyListeners();
    }
  }

  Future<String?> addToCart(int productId, String variant, int quantity, String color) async {
    try {
      final response = await addToCartUseCase(productId, variant, quantity, color);
      // Check the result field from the API response
      lastAddToCartSuccess = response['result'] == true;
      
      // Return the message from the API response
      final message = response['message'] as String?;
      
      notifyListeners();
      return message;
    } catch (e) {
      lastAddToCartSuccess = false;
      cartError = e.toString();
      String errorMessage = cartError;
      if (cartError.contains('Exception: ')) {
        errorMessage = cartError.replaceFirst('Exception: ', '');
      }
      notifyListeners();
      return errorMessage;
    }
  }

}