import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/logging/logger_service.dart';

class DataPopulatingService {
  final FirebaseFirestore _firestore;

  DataPopulatingService(this._firestore);

  Future<void> populateFirestoreFromJson() async {
    try {
      // Load the JSON file
      final jsonString =
          await rootBundle.loadString('assets/populate_json/languages.json');
      final jsonData = json.decode(jsonString) as List<dynamic>;

      // Ensure jsonData is a List<String>
      final languages = List<String>.from(jsonData);

      // Transform the languages to the desired structure
      final List<Map<String, dynamic>> transformedData =
          languages.map((language) => {language: <dynamic>[]}).toList();

      // Define the document path where you want to store the languages
      final DocumentReference languagesDoc = _firestore
          .collection(FirestoreCollections.typeAhead)
          .doc(FirestoreCollections.typeAheadLanguagesDoc);

      // Set the document data in Firestore
      await languagesDoc.set({'values': transformedData});
    } catch (e, stackTrace) {
      getIt<LoggerService>().logError(
        message: 'Error populating Firestore: $e',
        error: e,
        stackTrace: stackTrace,
      );
      // Handle the error appropriately
    }
  }
}
