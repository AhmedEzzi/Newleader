import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/order_details_model.dart';
import '../models/order_items_model.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderResponse> getOrders({int page = 1});
  Future<OrderDetailsResponse> getOrderDetails(int orderId);
  Future<OrderItemsResponse> getOrderItems(int orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiProvider apiProvider;

  OrderRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<OrderResponse> getOrders({int page = 1}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.purchaseHistory}?page=$page',
    );

    return OrderResponse.fromJson(response.data);
  }

  @override
  Future<OrderDetailsResponse> getOrderDetails(int orderId) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.purchaseHistoryDetails}/$orderId',
    );

    return OrderDetailsResponse.fromJson(response.data);
  }

  @override
  Future<OrderItemsResponse> getOrderItems(int orderId) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.purchaseHistoryItems}/$orderId',
    );

    return OrderItemsResponse.fromJson(response.data);
  }
}