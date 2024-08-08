class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class DataParsingException implements Exception {
  final String message;
  DataParsingException(this.message);
}
