import 'package:cryphub/domain/network/network_response.dart';
import 'package:cryphub/domain/network/network_service.dart';
import 'package:cryphub/domain/network/network_timeout_exception.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: INetworkService)
class NetworkService implements INetworkService {
  final Dio dio;

  NetworkService(this.dio);

  @override
  Future<NetworkResponse> delete(String url,
      {Map<String, dynamic>? headers, Map<String, dynamic>? queryParameters}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<NetworkResponse> get(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return true;
          },
          sendTimeout: 5000,
          receiveTimeout: 5000,
        ),
      );
      return NetworkResponse(
        status: response.statusCode!,
        data: response.data,
      );
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.sendTimeout:
          throw NetworkTimeoutException();
        case DioErrorType.receiveTimeout:
          throw NetworkTimeoutException();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<NetworkResponse> post(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<NetworkResponse> update(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
