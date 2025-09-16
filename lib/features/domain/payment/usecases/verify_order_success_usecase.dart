import '../repositories/payment_repository.dart';

class VerifyOrderSuccessUseCase {
  final PaymentRepository repository;

  VerifyOrderSuccessUseCase(this.repository);

  Future<Map<String, dynamic>> call(String orderId) async {
    return await repository.verifyOrderSuccess(orderId);
  }
}
