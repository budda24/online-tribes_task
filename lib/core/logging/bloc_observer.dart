import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

class SimpleBlocObserver extends BlocObserver {
  final LoggerService logger = getIt<LoggerService>();

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.logInfo(message: 'Bloc Event: ${bloc.runtimeType} $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.logInfo(message: 'Bloc Transition: ${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.logError(
      message: 'Bloc Error: ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
