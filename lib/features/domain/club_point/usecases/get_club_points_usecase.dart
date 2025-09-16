import '../entities/club_point.dart';
import '../repositories/club_point_repository.dart';

class GetClubPointsUseCase {
  final ClubPointRepository repository;

  GetClubPointsUseCase(this.repository);

  Future<List<ClubPoint>> call({int page = 1}) {
    return repository.getClubPoints(page: page);
  }
} 