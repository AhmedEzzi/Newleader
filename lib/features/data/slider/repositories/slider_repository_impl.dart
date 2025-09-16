// First, let's modify your SliderRepositoryImpl to include caching functionality
// lib/features/data/slider/repositories/slider_repository_impl.dart

import 'dart:convert';
import '../../../domain/slider/repositories/slider_repository.dart';
import '../datasources/slider_remote_datasource.dart';
import '../model/slider_model.dart';
import '../../../../core/utils/local_storage/shared_pref.dart';

class SliderRepositoryImpl implements SliderRepository {
  final SliderRemoteDataSource sliderRemoteDataSource;
  static const String SLIDER_CACHE_KEY = 'slider_cache';
  static const String SLIDER_CACHE_TIMESTAMP_KEY = 'slider_cache_timestamp';
  static const int CACHE_DURATION_IN_DAYS = 2;

  SliderRepositoryImpl(this.sliderRemoteDataSource);

  @override
  Future<SliderResponseModel> getSliders({bool refresh = false}) async {
    // If refresh is true, skip cache and get fresh data
    if (refresh) {
      return _fetchAndCacheData();
    }

    // Check if cache exists and is valid
    final cachedData = await _getCachedData();
    if (cachedData != null) {
      return cachedData;
    }

    // If no valid cache, fetch fresh data
    return _fetchAndCacheData();
  }

  Future<SliderResponseModel?> _getCachedData() async {
    final cachedDataJson = SharedPrefs.getString(SLIDER_CACHE_KEY);
    final cachedTimestampStr = SharedPrefs.getString(SLIDER_CACHE_TIMESTAMP_KEY);

    if (cachedDataJson != null && cachedTimestampStr != null) {
      final cachedTimestamp = int.parse(cachedTimestampStr);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final timeElapsed = currentTime - cachedTimestamp;
      final cacheDurationMs = CACHE_DURATION_IN_DAYS * 24 * 60 * 60 * 1000;

      // Check if cache is still valid (less than 2 days old)
      if (timeElapsed < cacheDurationMs) {
        try {
          final Map<String, dynamic> jsonMap = json.decode(cachedDataJson);
          return SliderResponseModel.fromJson(jsonMap);
        } catch (e) {
          // If parsing fails, return null to fetch fresh data
          return null;
        }
      }
    }
    return null; // Cache doesn't exist or is expired
  }

  Future<SliderResponseModel> _fetchAndCacheData() async {
    final response = await sliderRemoteDataSource.getSliders();

    // Cache the response
    await SharedPrefs.setString(SLIDER_CACHE_KEY, json.encode(response.toJson()));

    // Cache the timestamp
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
    await SharedPrefs.setString(SLIDER_CACHE_TIMESTAMP_KEY, currentTimestamp);

    return response;
  }
}