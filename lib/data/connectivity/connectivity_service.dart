import 'dart:io';

import 'package:cryphub/domain/connectivity/connectivity_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IConnectivityService)
class ConnectivityService implements IConnectivityService {
  ConnectivityService();

  @override
  Future<bool> get hasConnection async {
    try {
      // https://stackoverflow.com/questions/49648022/check-whether-there-is-an-internet-connection-available-on-flutter-app
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
