import '../repositories/order_repository.dart';

class GetOrdersPaginationUseCase {
  final OrderRepository orderRepository;

  GetOrdersPaginationUseCase(this.orderRepository);

  Future<Map<String, dynamic>> call({int page = 1}) async {
    return await orderRepository.getOrdersPagination(page: page);
  }
}