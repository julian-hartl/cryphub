import 'package:bloc/bloc.dart';
import 'package:cryphub/data/logger/logger_provider.dart';
import 'package:cryphub/domain/connectivity/connectivity_service.dart';
import 'package:cryphub/domain/core/cache/cache.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';
part 'splash_screen_bloc.freezed.dart';

@lazySingleton
class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState>
    with LoggerProvider {
  final IConnectivityService connectivityService;

  SplashScreenBloc(
    this.connectivityService,
  ) : super(const SplashScreenState.initial()) {
    on<_Initialize>((event, emit) async {
      try {
        await Future.wait([
          GetStorage.init(),
          Cache.init(),
        ]);
        final hasConnection = await connectivityService.hasConnection;
        if (!hasConnection) {
          emit(const SplashScreenState.noConnection());
        } else {
          emit(const SplashScreenState.initializationSuccess());
        }
      } catch (e, st) {
        logger.error('', e, st);
        emit(const SplashScreenState.errorOccurred());
      }
    });

    on<_RecheckNetwork>((event, emit) async {
      final hasConnection = await connectivityService.hasConnection;
      if (!hasConnection) {
        emit(const SplashScreenState.noConnection());
      } else {
        emit(const SplashScreenState.initializationSuccess());
      }
    });
  }
}
