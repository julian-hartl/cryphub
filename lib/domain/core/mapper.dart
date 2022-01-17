abstract class Mapper<T extends Object> {
  /// Converts [t] to json
  Map<String, dynamic> toJson(T t);

  /// Converts [json] to [Object] of type [T]
  T fromJson(Map<String, dynamic> json);
}
