class NetworkTimeoutException implements Exception {
  @override
  String toString() => '$runtimeType: Request timeouted.';
}
