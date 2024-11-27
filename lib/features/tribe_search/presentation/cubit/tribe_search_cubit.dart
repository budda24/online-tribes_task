import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/models/type_ahead_search_data_model.dart';
import 'package:online_tribes/features/tribe_search/data/tribe_search_repository.dart';
import 'package:online_tribes/features/tribe_search/presentation/cubit/tribe_search_state.dart';

class TribeSearchCubit extends Cubit<TribeSearchState> {
  final TribeSearchRepository _tribeSearchRepository;

  TribeSearchCubit(
    this._tribeSearchRepository,
  ) : super(
          const TribeSearchState.initial(),
        );

  Future<void> loadSearchData() async {
    emit(const TribeSearchState.loading());

    final response = await _tribeSearchRepository.loadDataCollections();

    response.fold(
      (failure) => emit(TribeSearchState.failure(failure)),
      (success) => emit(const TribeSearchState.ready()),
    );
  }

  void onSuggestionsCleared() {
    emit(const TribeSearchState.searchSuggestionsCleared());
  }

  Future<void> onSuggestionRequest(String phrase) async {
    final response = await _tribeSearchRepository.onSuggestionRequest(phrase);

    response.fold(
      (failure) => emit(TribeSearchState.failure(failure)),
      (suggestions) => emit(
        TribeSearchState.searchSuggestionsPopulated(suggestions),
      ),
    );
  }

  Future<void> onSuggestionTap(TypeAheadSearchDataModel item) async {
    await state.maybeWhen(
      searchSuggestionsPopulated: (searchSuggestions) async {
        await findAndPopulateTribesSuggestion(
          searchSuggestions: searchSuggestions,
          selectedSuggestionItem: item,
        );
      },
      tribeSuggestionsPopulated:
          (searchPhrase, searchSuggestions, tribeSuggestions) async {
        if (item.key == searchPhrase) return;

        await findAndPopulateTribesSuggestion(
          searchSuggestions: searchSuggestions,
          selectedSuggestionItem: item,
        );
      },
      orElse: () {},
    );
  }

  Future<void> findAndPopulateTribesSuggestion({
    required List<TypeAheadSearchDataModel> searchSuggestions,
    required TypeAheadSearchDataModel selectedSuggestionItem,
  }) async {
    emit(TribeSearchState.tribeSuggestionsLoading(searchSuggestions));

    final response = await _tribeSearchRepository
        .findTribesSuggestions(selectedSuggestionItem.tribeIds);

    response.fold(
      (failure) => emit(TribeSearchState.failure(failure)),
      (tribeSuggestions) => emit(
        TribeSearchState.tribeSuggestionsPopulated(
          selectedSuggestionItem.key,
          searchSuggestions,
          tribeSuggestions,
        ),
      ),
    );
  }
}
