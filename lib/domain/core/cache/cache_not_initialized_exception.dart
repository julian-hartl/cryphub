class CacheNotInitializedException implements Exception {
  final String message = 'Cache has not been initialized.';

  @override
  String toString() => '$runtimeType: $message';
}
