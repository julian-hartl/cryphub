class AlreadyInitializedException implements Exception {
  final String message = 'Cache has already been initialized.';

  @override
  String toString() => '$runtimeType: $message';
}
