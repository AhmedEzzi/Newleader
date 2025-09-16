import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/club_point_model.dart';

abstract class ClubPointDataSource {
  Future<ClubPointResponse> getClubPoints({int page = 1});
  Future<bool> convertToWallet();
}

class ClubPointDataSourceImpl implements ClubPointDataSource {
  final ApiProvider apiProvider;

  ClubPointDataSourceImpl(this.apiProvider);

  @override
  Future<ClubPointResponse> getClubPoints({int page = 1}) async {
    try {
      final response = await apiProvider.get(
        '/clubpoint/get-list',
        queryParameters: {'page': page},
      );
      return ClubPointResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load club points: $e');
    }
  }

  @override
  Future<bool> convertToWallet() async {
    try {
      final response = await apiProvider.post('/clubpoint/convert-into-wallet');
      return response.data['success'] ?? false;
    } catch (e) {
      throw Exception('Failed to convert points to wallet: $e');
    }
  }
} 