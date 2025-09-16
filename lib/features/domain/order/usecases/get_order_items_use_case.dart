import '../entities/order_item.dart';
import '../repositories/order_repository.dart';

class GetOrderItemsUseCase {
  final OrderRepository orderRepository;

  GetOrderItemsUseCase(this.orderRepository);

  Future<List<OrderItem>> call(int orderId) async {
    return await orderRepository.getOrderItems(orderId);
  }
}