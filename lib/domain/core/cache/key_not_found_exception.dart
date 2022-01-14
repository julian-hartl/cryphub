class KeyNotFoundException {
  final dynamic key;
  late final String message;

  KeyNotFoundException(this.key) {
    message = 'Key $key was not found.';
  }

  @override
  String toString() => '$runtimeType: $message';
}
