import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_response.freezed.dart';

/// A simple network response.
///
/// [status] is the status code of the request.
///
/// [data] is the returned data.
@freezed
class NetworkResponse with _$NetworkResponse {
  const factory NetworkResponse({
    required int status,
    required dynamic data,
  }) = _NetworkResponse;
}
