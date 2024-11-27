import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/models/type_ahead_search_data_model.dart';
import 'package:online_tribes/features/tribe_search/domain/models/tribe_suggestion_model.dart';

part 'tribe_search_state.freezed.dart';

@freezed
abstract class TribeSearchState with _$TribeSearchState {
  const factory TribeSearchState.initial() = TribeSearchInitial;
  const factory TribeSearchState.loading() = TribeSearchLoading;
  const factory TribeSearchState.ready() = TribeSearchReady;
  const factory TribeSearchState.searchSuggestionsPopulated(
    List<TypeAheadSearchDataModel> suggestions,
  ) = TribeSearchSuggestionsPopulated;
  const factory TribeSearchState.searchSuggestionsCleared() =
      TribeSearchSuggestionsCleared;
  const factory TribeSearchState.tribeSuggestionsLoading(
    List<TypeAheadSearchDataModel> suggestions,
  ) = TribeSuggestionsLoading;
  const factory TribeSearchState.tribeSuggestionsPopulated(
    String searchPhraseSelected,
    List<TypeAheadSearchDataModel> suggestions,
    List<TribeSuggestionModel> tribeSuggestions,
  ) = TribeSuggestionsPopulated;
  const factory TribeSearchState.failure(BaseApiError<dynamic> error) =
      TribeSearchFailure;
}
