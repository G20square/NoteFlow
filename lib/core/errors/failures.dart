abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Please check your connection.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected error occurred.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local data error.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}
