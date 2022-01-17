import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_response.freezed.dart';

@freezed
class NetworkResponse with _$NetworkResponse {
  const factory NetworkResponse({
    required int status,
    required dynamic data,
  }) = _NetworkResponse;
}
