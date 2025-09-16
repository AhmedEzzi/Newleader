// lib/core/errors/exceptions.dart

/// Base exception class for all server related exceptions
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when a network issue occurs
class NetworkException extends ServerException {
  const NetworkException(String message) : super(message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when a request times out
class TimeoutException extends ServerException {
  const TimeoutException(String message) : super(message);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when user is not authenticated
class UnauthorizedException extends ServerException {
  const UnauthorizedException(String message) : super(message);

  @override
  String toString() => '$message';
}

/// Exception thrown when user is forbidden from accessing a resource
class ForbiddenException extends ServerException {
  const ForbiddenException(String message) : super(message);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException extends ServerException {
  const NotFoundException(String message) : super(message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when validation fails
class ValidationException extends ServerException {
  final Map<String, dynamic>? errors;

  const ValidationException(String message, {this.errors}) : super(message);

  @override
  String toString() => 'ValidationException: $message, Errors: $errors';
}

/// Exception thrown when a request is cancelled
class RequestCancelledException extends ServerException {
  const RequestCancelledException(String message) : super(message);

  @override
  String toString() => 'RequestCancelledException: $message';
}