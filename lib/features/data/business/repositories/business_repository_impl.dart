import '../../business/datasources/business_remote_datasource.dart';
import '../../../domain/business/entities/business_setting.dart';
import '../../../domain/business/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDataSource remoteDataSource;

  BusinessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BusinessSetting>> getBusinessSettings() async {
    try {
      final models = await remoteDataSource.getBusinessSettings();
      return models;
    } catch (e) {
      throw Exception('Failed to fetch business settings: $e');
    }
  }
} 