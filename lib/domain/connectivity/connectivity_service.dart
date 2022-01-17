import 'connectvitiy_type.dart';

abstract class IConnectivityService {
  Future<bool> get hasConnection;
}
