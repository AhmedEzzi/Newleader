/// Base exception class for all API exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode; // Optional HTTP status code
  final dynamic error; // Original error object
  final StackTrace? stackTrace; // Stack trace for debugging

  ApiException(this.message, {this.statusCode, this.error, this.stackTrace});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? " (HTTP $statusCode)" : ""}';
  }
}

/// Exception thrown when there's a network connectivity issue
class NetworkException extends ApiException {
  NetworkException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, error: error, stackTrace: stackTrace);
}

/// Exception thrown when the API response couldn't be parsed
class ParseException extends ApiException {
  ParseException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, error: error, stackTrace: stackTrace);
}

/// Exception thrown for 401 Unauthorized responses
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, statusCode: 401, error: error, stackTrace: stackTrace);
}

/// Exception thrown for 403 Forbidden responses
class ForbiddenException extends ApiException {
  ForbiddenException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, statusCode: 403, error: error, stackTrace: stackTrace);
}

/// Exception thrown for 404 Not Found responses
class NotFoundException extends ApiException {
  NotFoundException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, statusCode: 404, error: error, stackTrace: stackTrace);
}

/// Exception thrown when a user is not found (specific business case)
class UserNotFoundException extends NotFoundException {
  UserNotFoundException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, error: error, stackTrace: stackTrace);
}

/// Exception thrown for 422 Validation Errors
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException(String message, {this.errors, dynamic error, StackTrace? stackTrace})
      : super(message, statusCode: 422, error: error, stackTrace: stackTrace);
}

/// Exception thrown when a request is cancelled
class RequestCancelledException extends ApiException {
  RequestCancelledException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, error: error, stackTrace: stackTrace);
}

/// Exception thrown for request timeouts
class TimeoutException extends ApiException {
  TimeoutException(String message, {dynamic error, StackTrace? stackTrace})
      : super(message, error: error, stackTrace: stackTrace);
}

/// Exception thrown for 500+ Server Error responses
class ServerException extends ApiException {
  ServerException(String message, {int statusCode = 500, dynamic error, StackTrace? stackTrace})
      : super(message, statusCode: statusCode, error: error, stackTrace: stackTrace);
}

/// Generic HTTP Exception for unexpected status codes
class HttpException extends ApiException {
  HttpException(int statusCode, String message, {dynamic error, StackTrace? stackTrace})
      : super(message, statusCode: statusCode, error: error, stackTrace: stackTrace);
}