class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException({required this.message, this.stackTrace});
}

class ServerException extends AppException {
  ServerException({required super.message, super.stackTrace});
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.stackTrace});
}