import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class TypeAheadService {
  final FirebaseFirestore _firestore;

  TypeAheadService(this._firestore);

  Future<List<String>> fetchSuggestions({
    required String document,
    required String query,
  }) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirestoreCollections.typeAhead)
          .doc(document)
          .get();
      final data = docSnapshot.data();
      if (data == null || data['values'] == null) return [];

      final rawValues = data['values'];
      var keys = <String>[];

      if (rawValues is Map<String, dynamic>) {
        keys = rawValues.keys.toList();
      } else if (rawValues is List<dynamic>) {
        keys = rawValues
            .whereType<Map<String, dynamic>>()
            .expand((map) => map.keys)
            .whereType<String>()
            .toList();
      }

      return keys
          .where((key) => key.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> fetchAllSuggestions({
    required String document,
  }) async {
    final docSnapshot = await _firestore
        .collection(FirestoreCollections.typeAhead)
        .doc(document)
        .get();
    final data = docSnapshot.data();
    if (data == null || data['values'] == null) return [];

    if (data['values'] is List<dynamic>) {
      final valuesDynamicList = data['values'] as List<dynamic>;
      // Filter and cast each element to Map<String, dynamic>
      final values =
          valuesDynamicList.whereType<Map<String, dynamic>>().toList();
      // Get the keys from each map and flatten them into a single list
      return values.expand((element) => element.keys).toList();
    } else {
      // Handle unexpected type
      return [];
    }
  }

  Future<void> addNewEntry(String document, String newEntry) async {
    final docRef =
        _firestore.collection(FirestoreCollections.typeAhead).doc(document);
    final sanitizedEntry = newEntry.sanitizeFieldName();

    // Create a new map entry where the key is the sanitized entry and the value is an empty list.
    final newMapEntry = {sanitizedEntry: <dynamic>[]};

    await docRef.set(
      {
        'values': FieldValue.arrayUnion([newMapEntry]),
      },
      SetOptions(merge: true),
    );
  }
}
