class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException({required this.message, this.stackTrace});
}

class ServerException extends AppException {
  ServerException({required String message, StackTrace? stackTrace})
      : super(message: message, stackTrace: stackTrace);
}

class NetworkException extends AppException {
  NetworkException({required String message, StackTrace? stackTrace})
      : super(message: message, stackTrace: stackTrace);
}