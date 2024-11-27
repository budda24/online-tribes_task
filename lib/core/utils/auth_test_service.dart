import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

class AuthTestService {
  final FirebaseFirestore firestore;
  final LoggerService logger;

  AuthTestService(this.firestore, this.logger);
  Future<void> testAuthConnection() async {
    try {
      // Generate a unique email using a timestamp or random number
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomSuffix = Random().nextInt(100000); // Optional randomness
      final uniqueEmail = 'testuser+$timestamp$randomSuffix@example.com';

      // Create a test user with a unique email
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: uniqueEmail,
        password: 'password123',
      );
      logger.logInfo(
        message:
            'Auth: Successfully created user: ${userCredential.user?.uid} with email: $uniqueEmail',
      );

      // Sign in the test user
      final signInCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: uniqueEmail,
        password: 'password123',
      );
      logger.logInfo(
        message:
            'Auth: Successfully signed in user: ${signInCredential.user?.uid} with email: $uniqueEmail',
      );
    } catch (e, stackTrace) {
      logger.logError(
        message: 'Auth: Error testing connection: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
