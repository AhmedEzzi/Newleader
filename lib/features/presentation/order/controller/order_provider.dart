// lib/features/presentation/order/controller/order_provider.dart
import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/order/entities/order.dart';
import '../../../domain/order/entities/order_details.dart';
import '../../../domain/order/entities/order_item.dart';
import '../../../domain/order/usecases/get_order_details_use_case.dart';
import '../../../domain/order/usecases/get_order_items_use_case.dart';
import '../../../domain/order/usecases/get_orders_pagination_use_case.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersPaginationUseCase getOrdersPaginationUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final GetOrderItemsUseCase getOrderItemsUseCase;

  OrderProvider({
    required this.getOrdersPaginationUseCase,
    required this.getOrderDetailsUseCase,
    required this.getOrderItemsUseCase,
  });

  LoadingState ordersState = LoadingState.loading;
  LoadingState orderDetailsState = LoadingState.loading;
  LoadingState orderItemsState = LoadingState.loading;

  List<Order> orders = [];
  OrderDetails? selectedOrderDetails;
  List<OrderItem> orderItems = [];

  String ordersError = '';
  String orderDetailsError = '';
  String orderItemsError = '';

  // Pagination data
  int currentPage = 1;
  int lastPage = 1;
  bool hasNextPage = false;
  bool isLoadingMore = false;
  Map<String, dynamic> paginationMeta = {};
  Map<String, dynamic> paginationLinks = {}; // Changed from Map<String, String>

  Future<void> fetchOrders({int page = 1}) async {
    try {
      if (page == 1) {
        ordersState = LoadingState.loading;
        notifyListeners();
      } else {
        isLoadingMore = true;
        notifyListeners();
      }

      final result = await getOrdersPaginationUseCase(page: page);

      if (page == 1) {
        orders = result['orders'] as List<Order>;
      } else {
        orders.addAll(result['orders'] as List<Order>);
      }

      // Safe handling of meta and links
      paginationMeta = result['meta'] as Map<String, dynamic>? ?? {};
      paginationLinks = result['links'] as Map<String, dynamic>? ?? {};

      // Safely extract current_page and last_page with null checks
      currentPage = (paginationMeta['current_page'] as int?) ?? 1;
      lastPage = (paginationMeta['last_page'] as int?) ?? 1;
      hasNextPage = currentPage < lastPage;

      ordersState = LoadingState.loaded;
    } catch (e) {
      print('Error fetching orders: $e'); // Add this for debugging
      if (page == 1) {
        ordersState = LoadingState.error;
        ordersError = e.toString();
      }
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreOrders() async {
    if (hasNextPage && !isLoadingMore) {
      await fetchOrders(page: currentPage + 1);
    }
  }

  Future<void> fetchOrderDetails(int orderId) async {
    try {
      orderDetailsState = LoadingState.loading;
      notifyListeners();

      selectedOrderDetails = await getOrderDetailsUseCase(orderId);
      orderDetailsState = LoadingState.loaded;
    } catch (e) {
      print('Error fetching order details: $e'); // Add this for debugging
      orderDetailsState = LoadingState.error;
      orderDetailsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchOrderItems(int orderId) async {
    try {
      orderItemsState = LoadingState.loading;
      notifyListeners();

      orderItems = await getOrderItemsUseCase(orderId);
      orderItemsState = LoadingState.loaded;
    } catch (e) {
      print('Error fetching order items: $e'); // Add this for debugging
      orderItemsState = LoadingState.error;
      orderItemsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void refreshOrders() {
    currentPage = 1;
    orders = [];
    fetchOrders(page: 1);
  }
}