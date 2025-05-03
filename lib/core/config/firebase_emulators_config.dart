import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

class FirebaseEmulatorConfig {
  final LoggerService logger;

  FirebaseEmulatorConfig(this.logger);

  Future<void> connectToEmulators() async {
    try {
      // Firestore emulator
      FirebaseFirestore.instance.settings = const Settings(
        host: '10.0.2.2:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );
      logger.logInfo(message: 'Connected to Firestore emulator');
    } catch (e) {
      logger.logError(
        message: 'Failed to connect to Firestore emulator',
        error: e,
      );
    }

    try {
      // Authentication emulator
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      logger.logInfo(message: 'Connected to Authentication emulator');
    } catch (e) {
      logger.logError(
        message: 'Failed to connect to Authentication emulator',
        error: e,
      );
    }

    try {
      // Storage emulator
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      logger.logInfo(message: 'Connected to Storage emulator');
    } catch (e) {
      logger.logError(message: 'Failed to connect to Storage emulator: $e');
    }
  }
}
