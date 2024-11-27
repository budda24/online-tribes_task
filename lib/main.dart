import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_tribes/core/config/app_initializer.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/check_onboarding_complete_usecase.dart';
import 'package:online_tribes/router/app_routes.dart';
import 'package:online_tribes/theme/app_theme.dart';

final LoggerService _loggerService = LoggerService();
late GoRouter _router;

void main() async {
  // Create an instance of AppInitializer
  final appInitializer = AppInitializer(
    useEmulator: const bool.fromEnvironment('useEmulator'),
    populateFirestore: const bool.fromEnvironment('useEmulator'),
  );

  try {
    // Ensure any unhandled async errors are logged
    await runZonedGuarded(() async {
      // Ensure Flutter bindings are initialized
      WidgetsFlutterBinding.ensureInitialized();
      // Initialize the app (for things like Firebase, dependencies, etc.)
      await appInitializer.initialize();

      final onboardingCompleted = await getIt<CheckOnboardingCompleteUseCase>()
          .call(HiveKeys.isUserOnboardingComplete);

      // Set up GoRouter after initialization to ensure proper routing
      _router = GoRouter(
        debugLogDiagnostics: true,
        routes: $appRoutes,
        initialLocation: onboardingCompleted ? '/auth' : '/user-onboarding',
      );
      runApp(const MyApp());
    }, (error, stackTrace) {
      _loggerService.logError(
        message: 'Unhandled error caught in runZonedGuarded',
        error: error,
        stackTrace: stackTrace,
        time: DateTime.now(),
      );
    });

    // Catch framework-level errors
    FlutterError.onError = (details) {
      _loggerService.logError(
        message: 'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
        time: DateTime.now(),
      );
    };
  } catch (error, stackTrace) {
    // Log any initialization errors before runApp
    _loggerService.logError(
      message: 'Error during app initialization',
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, widget) => KeyboardDismissOnTap(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: _router.routerDelegate,
          routeInformationParser: _router.routeInformationParser,
          routeInformationProvider: _router.routeInformationProvider,
          theme: AppTheme.defaultTheme().themeData,
          title: 'Flutter Demo',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
