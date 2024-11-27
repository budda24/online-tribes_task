import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

class FirestoreTestService {
  final FirebaseFirestore firestore;
  final LoggerService logger;

  FirestoreTestService(this.firestore, this.logger);

  Future<void> testFirestoreConnection() async {
    try {
      // Reference to a test collection
      final CollectionReference testCollection = firestore.collection('test');

      // Document data
      final testData = <String, dynamic>{
        'name': 'Test User',
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add a document to the test collection
      final docRef = await testCollection.add(testData);
      logger.logInfo(message: 'Document added with ID: ${docRef.id}');

      // Read the document back
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        logger.logInfo(
          message: 'Successfully read document: ${docSnapshot.data()}',
        );
      } else {
        logger.logError(message: 'Failed to read the document');
      }
    } catch (e) {
      logger.logError(message: 'Error testing Firestore connection: $e');
    }
  }
}
