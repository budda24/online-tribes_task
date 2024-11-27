import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_tribes/core/config/firebase_emulators_config.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/logging/bloc_observer.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/data_populating_service.dart';
import 'package:online_tribes/firebase_options.dart';

class AppInitializer {
  final bool useEmulator;
  final bool populateFirestore;

  AppInitializer({
    required this.useEmulator,
    required this.populateFirestore,
  });

  /// Initializes the app by configuring Firebase, Hive, and other services.
  Future<void> initialize() async {
    // Configure dependencies using get_it
    configureDependencies();

    final logger = getIt<LoggerService>();

    await dotenv.load();

    // Initialize Firebase
    await _initializeFirebase(logger);

    _setupCrashlytics();

    // Optionally connect to Firebase emulators
    if (useEmulator) {
      await _connectToFirebaseEmulator(logger);
    }

    // Optionally populate Firestore with initial data
    if (populateFirestore) {
      await getIt<DataPopulatingService>().populateFirestoreFromJson();
    }

    // Initialize Hive
    await Hive.initFlutter('online-tribes');

    // Set up Bloc observer
    Bloc.observer = SimpleBlocObserver();
  }

  /// Initializes Firebase.
  Future<void> _initializeFirebase(LoggerService logger) async {
    try {
      // Check if Firebase is already initialized

      await Firebase.initializeApp(
        name: 'dev project',
        options: DefaultFirebaseOptions.currentPlatform,
      );

      logger.logInfo(message: 'Firebase initialized successfully');
    } catch (e) {
      logger.logError(
        message: 'Error initializing Firebase: ',
        error: e,
      );
    }
  }

  /// Connects to Firebase emulators if the emulator flag is set.
  Future<void> _connectToFirebaseEmulator(LoggerService logger) async {
    final emulatorConfig = FirebaseEmulatorConfig(logger);
    await emulatorConfig.connectToEmulators();

    /* // Test Firestore and Storage connection
    await AuthTestService(FirebaseFirestore.instance, logger)
        .testAuthConnection();
    await FirebaseStorageTestService(FirebaseFirestore.instance, logger)
        .testStorageConnection(); */
  }

  void _setupCrashlytics() {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
