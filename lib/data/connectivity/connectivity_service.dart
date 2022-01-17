import 'dart:io';

import 'package:cryphub/domain/connectivity/connectivity_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IConnectivityService)
class ConnectivityService implements IConnectivityService {
  ConnectivityService();

  @override
  Future<bool> get hasConnection async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
