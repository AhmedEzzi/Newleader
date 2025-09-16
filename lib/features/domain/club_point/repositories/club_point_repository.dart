import '../entities/club_point.dart';
 
abstract class ClubPointRepository {
  Future<List<ClubPoint>> getClubPoints({int page = 1});
  Future<bool> convertToWallet();
} 