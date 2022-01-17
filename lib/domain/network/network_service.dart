import 'network_response.dart';

abstract class INetworkService {
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
