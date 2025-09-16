import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/api/rest_api_provider.dart';
import '../models/business_setting_model.dart';

abstract class BusinessRemoteDataSource {
  Future<List<BusinessSettingModel>> getBusinessSettings();
}

class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final RestApiProvider apiProvider;

  BusinessRemoteDataSourceImpl({required this.apiProvider});

  @override
  Future<List<BusinessSettingModel>> getBusinessSettings() async {
    try {
      final response = await apiProvider.get(
        LaravelApiEndPoint.businessSettings,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> settingsData = data['data'];
          return settingsData
              .map((item) => BusinessSettingModel.fromJson(item))
              .toList();
        }
        throw Exception('Failed to load business settings: ${data['message']}');
      }
      
      throw Exception('Failed to load business settings. Status: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching business settings: $e');
    }
  }
} 