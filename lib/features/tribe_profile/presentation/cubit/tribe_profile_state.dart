import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/tribe_profile_data.dart';

part 'tribe_profile_state.freezed.dart';

@freezed
class TribeProfileState with _$TribeProfileState {
  const factory TribeProfileState.initial() = _TribeProfileInitial;
  const factory TribeProfileState.loading() = TribeProfileLoading;
  const factory TribeProfileState.loaded(
    TribeProfileData data,
  ) = TribeProfileLoaded;
  const factory TribeProfileState.failure(BaseApiError<dynamic> error) =
      TribeProfileFailure;
}
