// ignore_for_file: no_runtimetype_tostring

import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/extensions/string_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/models/type_ahead_search_data_model.dart';
import 'package:online_tribes/core/services/tribe_search_service.dart';
import 'package:online_tribes/core/services/type_ahead_data_collector.dart';
import 'package:online_tribes/features/tribe_search/data/models/tribe_search_error_reason.dart';
import 'package:online_tribes/features/tribe_search/domain/models/tribe_suggestion_model.dart';

class TribeSearchRepository {
  final TypeAheadSearchDataCollector _searchDataCollector;
  final TribeSearchService _tribeSearchService;
  final LoggerService _logger;

  TribeSearchRepository({
    required TypeAheadSearchDataCollector searchDataCollector,
    required TribeSearchService tribeSearchService,
    required LoggerService logger,
  })  : _searchDataCollector = searchDataCollector,
        _tribeSearchService = tribeSearchService,
        _logger = logger;

  Future<Either<BaseApiError<dynamic>, void>> loadDataCollections() async {
    try {
      _logger.logInfo(
        message: '[$runtimeType] Loading search data collections',
      );

      await _searchDataCollector.loadData();
      return const Right(null);
    } catch (ex, stackTrace) {
      _logger.logError(
        message:
            '[$runtimeType] An error occurred while fetching search data collections',
        error: ex.toString(),
        stackTrace: stackTrace,
      );

      return const Left(
        BaseApiError(reason: TribeSearchErrorReason.unknown),
      );
    }
  }

  Future<Either<BaseApiError<dynamic>, List<TypeAheadSearchDataModel>>>
      onSuggestionRequest(
    String phrase,
  ) async {
    try {
      _logger.logInfo(
        message: '[$runtimeType] Looking for suggestions in search data',
      );

      final normalizedPhrase = _normalizeSearchString(phrase);

      final suggestions = _searchDataCollector.searchData.where(
        (element) {
          final key = _normalizeSearchString(element.key);

          return key.startsWith(normalizedPhrase) ||
              key.contains(normalizedPhrase) ||
              key.endsWith(normalizedPhrase);
        },
      ).toList();

      return Right(suggestions);
    } catch (ex, stackTrace) {
      _logger.logError(
        message:
            '[$runtimeType] An error occurred while looking for suggestions in search data',
        error: ex.toString(),
        stackTrace: stackTrace,
      );

      return const Left(
        BaseApiError(
          reason: TribeSearchErrorReason.unknown,
        ),
      );
    }
  }

  Future<Either<BaseApiError<dynamic>, List<TribeSuggestionModel>>>
      findTribesSuggestions(
    List<String> tribeIds,
  ) async {
    try {
      _logger.logInfo(
        message: '[$runtimeType] Looking for tribes suggestions in database',
      );

      final tribesSuggestions =
          await _tribeSearchService.findTribesSuggestions(tribeIds);

      return Right(tribesSuggestions);
    } catch (ex, stackTrace) {
      _logger.logError(
        message:
            '[$runtimeType] An error occurred while looking for tribes suggestions in database',
        error: ex.toString(),
        stackTrace: stackTrace,
      );

      return const Left(
        BaseApiError(reason: TribeSearchErrorReason.unknown),
      );
    }
  }

  String _normalizeSearchString(String input) =>
      input.withoutDiacriticalMarks.removeWhitespace.toLowerCase();
}
