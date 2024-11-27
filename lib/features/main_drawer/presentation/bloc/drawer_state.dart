import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';

part 'drawer_state.freezed.dart';

@freezed
class StyledDrawerState with _$StyledDrawerState {
  const factory StyledDrawerState.initial() = _Initial;
  const factory StyledDrawerState.loading() = _Loading;
  const factory StyledDrawerState.loaded({
    required String userId,
    required String? profilePictureUrl,
    required List<TribeModel> userTribes,
  }) = _Loaded;
  const factory StyledDrawerState.error(BaseApiError<dynamic> error) = _Error;
}
