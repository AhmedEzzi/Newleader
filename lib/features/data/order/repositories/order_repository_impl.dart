// lib/features/data/order/repositories/order_repository_impl.dart
import '../../../domain/order/entities/order.dart';
import '../../../domain/order/entities/order_details.dart';
import '../../../domain/order/entities/order_item.dart';
import '../../../domain/order/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_details_model.dart';
import '../models/order_items_model.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Order>> getOrders({int page = 1}) async {
    final response = await remoteDataSource.getOrders(page: page);
    return response.data.map((order) => order.toEntity()).toList();
  }

  @override
  Future<OrderDetails> getOrderDetails(int orderId) async {
    final response = await remoteDataSource.getOrderDetails(orderId);
    if (response.data.isNotEmpty) {
      return response.data.first.toEntity();
    } else {
      throw Exception('Order details not found');
    }
  }

  @override
  Future<List<OrderItem>> getOrderItems(int orderId) async {
    final response = await remoteDataSource.getOrderItems(orderId);
    return response.data.map((item) => item.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> getOrdersPagination({int page = 1}) async {
    final response = await remoteDataSource.getOrders(page: page);
    return {
      'orders': response.data.map((order) => order.toEntity()).toList(),
      'meta': response.meta,
      'links': response.links, // This now safely handles dynamic values
    };
  }
}