import 'package:dio/dio.dart';

/// Abstract class that defines the contract for API providers
abstract class ApiProvider {
  /// Base URL for API endpoints
  String get baseUrl;

  /// Performs a GET request to the specified endpoint
  Future<Response<dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      });

  /// Performs a POST request to the specified endpoint
  Future<Response<dynamic>> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      });

  /// Performs a PUT request to the specified endpoint
  Future<Response<dynamic>> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      });

  /// Performs a DELETE request to the specified endpoint
  Future<Response<dynamic>> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      });

  /// Performs a PATCH request to the specified endpoint
  Future<Response<dynamic>> patch(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      });

  /// Sets the authentication token for future requests
  void setAuthToken(String token);

  /// Sets the language for API requests, typically modifying headers
  void setLanguage(String languageCode);
}
