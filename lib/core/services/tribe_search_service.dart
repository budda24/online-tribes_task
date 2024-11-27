import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/features/tribe_search/domain/models/tribe_suggestion_model.dart';

class TribeSearchService {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  TribeSearchService(
    this._firestore,
    this._logger,
  );

  Future<List<TribeSuggestionModel>> findTribesSuggestions(
    List<String> tribeIds,
  ) async {
    // We can query using max 10 ids per each request, so we have to divide ids
    // and set them in groups of max 10 each
    try {
      final chunkedListsOfIds = _chunkList(tribeIds);
      final tribeSuggestions = <TribeSuggestionModel>[];

      for (final listOfIds in chunkedListsOfIds) {
        final snapshot = await _firestore
            .collection(FirestoreCollections.tribes)
            .where('tribeId', whereIn: listOfIds)
            .get();

        if (snapshot.docs.isNotEmpty) {
          for (final doc in snapshot.docs) {
            tribeSuggestions.add(TribeSuggestionModel.fromJson(doc.data()));
          }
        }
      }

      return tribeSuggestions;
    } catch (ex, stackTrace) {
      _logger.logError(
        message: 'Error when looking for Tribe suggestions in Firestore',
        error: ex,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  List<List<String>> _chunkList(List<String> tribeIds) {
    const chunkSize = 10;

    final sublists = <List<String>>[];

    for (var i = 0; i < tribeIds.length; i += chunkSize) {
      final end =
          (i + chunkSize < tribeIds.length) ? i + chunkSize : tribeIds.length;
      sublists.add(tribeIds.sublist(i, end));
    }

    return sublists;
  }
}
