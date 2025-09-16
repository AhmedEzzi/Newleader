import '../entities/payment_type.dart';
import '../repositories/payment_repository.dart';

class GetPaymentTypesUseCase {
  final PaymentRepository repository;

  GetPaymentTypesUseCase(this.repository);

  Future<List<PaymentType>> call() async {
    return await repository.getPaymentTypes();
  }
}
