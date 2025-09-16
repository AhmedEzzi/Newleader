import '../entities/order_details.dart';
import '../repositories/order_repository.dart';

class GetOrderDetailsUseCase {
  final OrderRepository orderRepository;

  GetOrderDetailsUseCase(this.orderRepository);

  Future<OrderDetails> call(int orderId) async {
    return await orderRepository.getOrderDetails(orderId);
  }
}