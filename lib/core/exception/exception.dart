class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

class ForbiddenException implements Exception {
  final String message;

  const ForbiddenException(this.message);
}

class BadRequestException implements Exception {
  final String message;

  const BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException(this.message);
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);
}

class NoInternetException implements Exception {
  final String message;

  const NoInternetException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}
