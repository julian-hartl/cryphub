class JsonMapper<T> {
  final Map<String, dynamic> Function(T value) toJson;
  final T Function(Map<String, dynamic> json) fromJson;

  JsonMapper({required this.fromJson, required this.toJson});
}
