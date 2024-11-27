import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/models/type_ahead_search_data_model.dart';

class TypeAheadSearchDataCollector {
  final FirebaseFirestore _firestore;

  TypeAheadSearchDataCollector(this._firestore);

  List<TypeAheadSearchDataModel> get searchData => _searchData;
  var _searchData = <TypeAheadSearchDataModel>[];

  Future<void> loadData() async {
    _searchData = [
      ...await _fetchTribesSearchData(),
      ...await _fetchUsersSearchData(),
      ...await _fetchTypesSearchData(),
    ];
  }

  Future<List<TypeAheadSearchDataModel>> _fetchTribesSearchData() async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.typeAhead)
          .doc(FirestoreCollections.tribeNames)
          .get();

      if (doc.exists) {
        final response = TypeAheadSearchDataResponseModel.fromDocData(
          doc.data(),
        );

        return response.values;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Future<List<TypeAheadSearchDataModel>> _fetchUsersSearchData() async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.typeAhead)
          .doc(FirestoreCollections.userNames)
          .get();

      if (doc.exists) {
        final response = TypeAheadSearchDataResponseModel.fromDocData(
          doc.data(),
        );

        return response.values;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Future<List<TypeAheadSearchDataModel>> _fetchTypesSearchData() async {
    try {
      final docSnapshot = await _firestore
          .collection(FirestoreCollections.typeAhead)
          .doc(FirestoreCollections.typeAheadTypesDoc)
          .get();

      if (docSnapshot.exists) {
        final response = TypeAheadSearchDataResponseModel.fromDocData(
          docSnapshot.data(),
        );

        return response.values;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }
}
