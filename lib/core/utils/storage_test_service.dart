import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

class FirebaseStorageTestService {
  final FirebaseFirestore firestore;
  final LoggerService logger;

  FirebaseStorageTestService(this.firestore, this.logger);
  Future<void> testStorageConnection() async {
    try {
      // Reference to a test file in storage
      final storageRef =
          FirebaseStorage.instance.ref().child('test/test_file.txt');

      // Sample data to upload
      final data = Uint8List.fromList('Hello, world!'.codeUnits);

      // Upload the file
      final uploadTask = storageRef.putData(data);
      final snapshot = await uploadTask;
      logger.logInfo(
        message:
            'Storage: Successfully uploaded file: ${snapshot.metadata?.name}',
      );

      // Download the file
      final downloadedData = await storageRef.getData();
      if (downloadedData != null) {
        logger.logInfo(
          message:
              'Storage: Successfully downloaded file with data: ${String.fromCharCodes(downloadedData)}',
        );
      } else {
        logger.logError(message: 'Storage: Failed to download file');
      }
    } catch (e) {
      logger.logError(message: 'Storage: Error testing connection: $e');
    }
  }
}
