import '../entities/business_setting.dart';
import '../repositories/business_repository.dart';

class GetBusinessSettingsUseCase {
  final BusinessRepository repository;

  GetBusinessSettingsUseCase(this.repository);

  Future<List<BusinessSetting>> call() async {
    return await repository.getBusinessSettings();
  }
} 