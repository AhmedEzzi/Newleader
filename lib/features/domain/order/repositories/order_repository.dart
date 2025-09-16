import '../entities/order.dart';
import '../entities/order_details.dart';
import '../entities/order_item.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({int page = 1});
  Future<OrderDetails> getOrderDetails(int orderId);
  Future<List<OrderItem>> getOrderItems(int orderId);
  Future<Map<String, dynamic>> getOrdersPagination({int page = 1});
}