import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
/// Using Equatable for easy comparison in tests
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-related failures (API errors, 500, etc.)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Network-related failures (no internet, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

/// Cache-related failures (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Validation failures (invalid input, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}
