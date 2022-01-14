class ApiException implements Exception {
  late final String message;
  ApiException(String apiErrorMessage) {
    message = 'Api exception occurred: $apiErrorMessage';
  }

  @override
  String toString() => '$runtimeType: $message';
}
