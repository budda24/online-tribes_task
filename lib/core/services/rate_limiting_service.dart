import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';

class RateLimitingService {
  final FirebaseFirestore firestore;

  RateLimitingService(this.firestore);

  // Define constants for rate limiting
  static const int maxAttempts = 5;
  static const Duration attemptWindow = Duration(minutes: 15);

  Future<bool> checkRateLimit(String email) async {
    final docRef =
        firestore.collection(FirestoreCollections.loginAttempts).doc(email);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      final attemptCount = data?['count'] ?? 0;
      final lastAttempt = data?['lastAttempt']?.toDate() as DateTime?;

      if (lastAttempt != null) {
        final timeSinceLastAttempt = DateTime.now().difference(lastAttempt);
        if (attemptCount as int >= maxAttempts &&
            timeSinceLastAttempt < attemptWindow) {
          // Rate limit exceeded
          return true;
        } else if (timeSinceLastAttempt >= attemptWindow) {
          // Reset counter after the window has passed
          await resetRateLimit(email);
        }
      }
    }

    return false;
  }

  Future<void> incrementRateLimit(String email) async {
    final docRef =
        firestore.collection(FirestoreCollections.loginAttempts).doc(email);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      final attemptCount = data?['count'] ?? 0;
      await docRef.update({
        'count': attemptCount + 1,
        'lastAttempt': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.set({
        'count': 1,
        'lastAttempt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> resetRateLimit(String email) async {
    final docRef =
        firestore.collection(FirestoreCollections.loginAttempts).doc(email);
    await docRef.delete();
  }
}
