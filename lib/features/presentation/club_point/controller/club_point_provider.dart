import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/club_point/entities/club_point.dart';
import '../../../domain/club_point/usecases/convert_to_wallet_usecase.dart';
import '../../../domain/club_point/usecases/get_club_points_usecase.dart';

class ClubPointProvider extends ChangeNotifier {
  final GetClubPointsUseCase getClubPointsUseCase;
  final ConvertToWalletUseCase convertToWalletUseCase;

  List<ClubPoint> clubPoints = [];
  LoadingState clubPointsState = LoadingState.initial;
  LoadingState convertState = LoadingState.initial;
  String errorMessage = '';
  int currentPage = 1;
  bool hasMoreClubPoints = true;

  ClubPointProvider({
    required this.getClubPointsUseCase,
    required this.convertToWalletUseCase,
  });

  Future<void> fetchClubPoints({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMoreClubPoints = true;
      clubPoints = [];
    }

    if (!hasMoreClubPoints) return;

    try {
      clubPointsState = LoadingState.loading;
      notifyListeners();

      final points = await getClubPointsUseCase(page: currentPage);
      
      if (points.isEmpty) {
        hasMoreClubPoints = false;
      } else {
        clubPoints.addAll(points);
        currentPage++;
      }
      
      clubPointsState = LoadingState.loaded;
    } catch (e) {
      clubPointsState = LoadingState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> convertPointsToWallet() async {
    try {
      convertState = LoadingState.loading;
      notifyListeners();

      final success = await convertToWalletUseCase();
      
      if (success) {
        // Refresh club points after successful conversion
        await fetchClubPoints(refresh: true);
      }
      
      convertState = LoadingState.loaded;
    } catch (e) {
      convertState = LoadingState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Get total points
  String get totalPoints {
    double total = 0;
    for (var point in clubPoints) {
      try {
        total += double.tryParse(point.points.toString()) ?? 0;
      } catch (e) {
        // Handle parsing error
        print('Error parsing club points: ${point.points}');
      }
    }
    return total.toStringAsFixed(0);  // Return without decimal places
  }
} 