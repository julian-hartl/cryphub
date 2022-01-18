abstract class IConnectivityService {
  /// Returns `true` when device has a working internet connection.
  ///
  /// Returns `false` when device does not have a working internet connection.
  Future<bool> get hasConnection;
}
