import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisteredThirdPartyModules {
  @lazySingleton
  Dio dio() => Dio();

  @lazySingleton
  GetStorage getStorage() => GetStorage();

  @preResolve
  Future<SharedPreferences> sharedPreferences() =>
      SharedPreferences.getInstance();
}
