import 'dart:io';
import 'package:dio/dio.dart';
import 'package:leader_company/core/api/api_exceptions.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker/talker.dart';
import '../config/app_config.dart/app_config.dart';
import 'api_provider.dart';

// Custom language interceptor class
class _LanguageInterceptor extends Interceptor {
  final String languageCode;
  final Talker talker;

  _LanguageInterceptor(this.languageCode, this.talker);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = languageCode;
    talker.debug('Request language set to: $languageCode');
    super.onRequest(options, handler);
  }
}

class RestApiProvider implements ApiProvider {
  late Dio _dio;
  final AppConfig _appConfig = AppConfig();
  String _languageCode = 'en';
  final Talker _talker = Talker();

  RestApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _appConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: _appConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: _appConfig.receiveTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'System-Key': '123456',
          'Accept-Language': 'en',
        },
      ),
    );

    // Add auth token interceptor to dynamically check for token on each request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Dynamically add the auth token to each request if available
          if (AppStrings.token != null && AppStrings.token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${AppStrings.token}';
            _talker.debug('Adding auth token to request: ${options.uri}');
          }
          return handler.next(options);
        },
      ),
    );

    // Add logging if enabled
    if (_appConfig.enableLogging) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: _talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseHeaders: true,
            printResponseData: true,
            printResponseMessage: true,
          ),
        ),
      );
    }

    // Language Interceptor
    _dio.interceptors.add(
      _LanguageInterceptor(_languageCode, _talker),
    );
  }

  @override
  String get baseUrl => _appConfig.apiBaseUrl;

  @override
  Future<Response<dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      _talker.info('GET Request to: $endpoint');
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('GET Request Error: ${exception.toString()}', exception);
      throw exception;
    }
  }

  @override
  Future<Response<dynamic>> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      _talker.info('POST Request to: $endpoint');
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('POST Request Error: ${exception.toString()}', exception);
      throw exception;
    }
  }

  @override
  Future<Response<dynamic>> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      _talker.info('PUT Request to: $endpoint');
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('PUT Request Error: ${exception.toString()}', exception);
      throw exception;
    }
  }

  @override
  Future<Response<dynamic>> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      _talker.info('DELETE Request to: $endpoint');
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('DELETE Request Error: ${exception.toString()}', exception);
      throw exception;
    }
  }

  @override
  Future<Response<dynamic>> patch(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      _talker.info('PATCH Request to: $endpoint');
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('PATCH Request Error: ${exception.toString()}', exception);
      throw exception;
    }
  }

  @override
  void setAuthToken(String token) {
    _talker.debug('Setting auth token');
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void setLanguage(String languageCode) {
    try {
      _talker.debug('Setting language to: $languageCode');
      _languageCode = languageCode;

      // Update the existing Dio instance headers
      _dio.options.headers['Accept-Language'] = languageCode;

      // Remove existing language interceptors
      _dio.interceptors.removeWhere((interceptor) => interceptor is _LanguageInterceptor);

      // Add a fresh language interceptor
      _dio.interceptors.add(_LanguageInterceptor(languageCode, _talker));

      // Log the language change
      _talker.info('API language changed to: $languageCode');
    } catch (e) {
      _talker.error('Error changing API language: $e');
      print('Error loading language for API: $e. Using default language.');
    }
  }

  /// Handles Dio errors and throws appropriate exceptions
  Exception _handleDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          _talker.warning('Request timeout occurred', error);
          return TimeoutException('Request timeout', error: error);
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;

          _talker.error('Bad response: $statusCode', error);
          _talker.debug('Response data: $responseData');

          if (statusCode == 401) {
            // Check the response body for "User not found"
            final message =
            responseData is Map ? responseData['message'] : null;
            if (message == 'User not found') {
              return UserNotFoundException(message, error: error);
            }
            return UnauthorizedException('Unauthorized', error: error);
          } else if (statusCode == 403) {
            return ForbiddenException('Forbidden', error: error);
          } else if (statusCode == 404) {
            return NotFoundException('Resource not found', error: error);
          } else if (statusCode == 422) {
            final errors = responseData is Map ? responseData['errors'] : null;
            return ValidationException(
              'Validation error',
              errors: errors is Map ? Map<String, dynamic>.from(errors) : null,
              error: error,
            );
          } else {
            final message =
            responseData is Map
                ? responseData['message'] ?? 'Server error'
                : 'Server error';
            return ServerException(
              message,
              statusCode: statusCode ?? 500,
              error: error,
            );
          }
        case DioExceptionType.cancel:
          _talker.info('Request cancelled', error);
          return RequestCancelledException('Request cancelled', error: error);
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            _talker.warning('Network error: No internet connection', error);
            return NetworkException('No internet connection', error: error);
          }
          _talker.error('Unknown error: ${error.message}', error);
          return ServerException(
            error.message ?? 'Unknown error',
            error: error,
          );
        default:
          _talker.error('Server error: ${error.message}', error);
          return ServerException(error.message ?? 'Server error', error: error);
      }
    } else if (error is SocketException) {
      _talker.warning('Socket exception: No internet connection', error);
      return NetworkException('No internet connection', error: error);
    } else {
      _talker.error('Unexpected error type: ${error.toString()}', error);
      return ServerException(error.toString(), error: error);
    }
  }

  // Getter to expose the talker instance for external use
  Talker get talker => _talker;

  // Helper method to reset Dio client
  void resetClient() {
    try {
      // Close existing client
      try {
        _dio.close(force: true);
      } catch (_) {
        // Ignore errors when closing
      }

      // Create a new Dio instance
      _dio = Dio(
        BaseOptions(
          baseUrl: _appConfig.apiBaseUrl,
          connectTimeout: Duration(milliseconds: _appConfig.connectTimeout),
          receiveTimeout: Duration(milliseconds: _appConfig.receiveTimeout),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'System-Key': '123456',
            'Accept-Language': _languageCode,
          },
        ),
      );

      // Add auth token interceptor
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Dynamically add the auth token to each request if available
            if (AppStrings.token != null && AppStrings.token!.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer ${AppStrings.token}';
              _talker.debug('Adding auth token to request: ${options.uri}');
            }
            return handler.next(options);
          },
        ),
      );

      // Add logging if enabled
      if (_appConfig.enableLogging) {
        _dio.interceptors.add(
          TalkerDioLogger(
            talker: _talker,
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printRequestData: true,
              printResponseHeaders: true,
              printResponseData: true,
              printResponseMessage: true,
            ),
          ),
        );
      }

      // Add language interceptor
      _dio.interceptors.add(_LanguageInterceptor(_languageCode, _talker));

      _talker.info('Dio client reset successfully');
    } catch (e) {
      _talker.error('Error resetting Dio client: $e');
    }
  }
}
