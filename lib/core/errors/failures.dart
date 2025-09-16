// lib/core/errors/failures.dart

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message = ''});

  @override
  List<Object> get props => [message];
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred'}) : super(message: message);
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network connection failed'}) : super(message: message);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred'}) : super(message: message);
}

// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({String message = 'Authentication failed'}) : super(message: message);
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({
    String message = 'Validation failed',
    this.errors = const {},
  }) : super(message: message);

  @override
  List<Object> get props => [message, errors];
}

// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Resource not found'}) : super(message: message);
}

// Payment failures
class PaymentFailure extends Failure {
  const PaymentFailure({String message = 'Payment failed'}) : super(message: message);
}

// Custom failure for e-commerce specific errors
class ProductFailure extends Failure {
  const ProductFailure({String message = 'Product operation failed'}) : super(message: message);
}

class OrderFailure extends Failure {
  const OrderFailure({String message = 'Order operation failed'}) : super(message: message);
}