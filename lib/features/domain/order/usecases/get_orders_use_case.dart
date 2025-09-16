import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository orderRepository;

  GetOrdersUseCase(this.orderRepository);

  Future<List<Order>> call({int page = 1}) async {
    return await orderRepository.getOrders(page: page);
  }
}