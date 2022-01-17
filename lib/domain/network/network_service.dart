import 'package:cryphub/domain/network/network_timeout_exception.dart';

import 'network_response.dart';

abstract class INetworkService {
  /// Makes a get request to [url]
  /// [headers] are sent to server
  /// [queryParameters] are added to the end of the url
  /// Returns a [NetworkResponse].
  /// Throws a [NetworkTimeoutException] when either requested server does not receive the request or does not respond.
  Future<NetworkResponse> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse> post(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse> update(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse> delete(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  });
}
