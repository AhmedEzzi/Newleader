import '../../../../core/network/network_info.dart';
import '../../../domain/club_point/entities/club_point.dart';
import '../../../domain/club_point/repositories/club_point_repository.dart';
import '../datasources/club_point_datasource.dart';

class ClubPointRepositoryImpl implements ClubPointRepository {
  final ClubPointDataSource dataSource;
  final NetworkInfo networkInfo;

  ClubPointRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<List<ClubPoint>> getClubPoints({int page = 1}) async {
    if (await networkInfo.isConnected) {
      final response = await dataSource.getClubPoints(page: page);
      return response.data;
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<bool> convertToWallet() async {
    if (await networkInfo.isConnected) {
      return await dataSource.convertToWallet();
    } else {
      throw Exception('No internet connection');
    }
  }
} 