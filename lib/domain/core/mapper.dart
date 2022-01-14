abstract class Mapper<T> {
  Map<String, dynamic> toJson(T t);
  T fromJson(Map<String, dynamic> json);
}
