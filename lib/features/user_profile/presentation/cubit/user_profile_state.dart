import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_tribes.dart';
part 'user_profile_state.freezed.dart';

@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState.initial() = _Initial;
  const factory UserProfileState.loading() = _Loading;
  const factory UserProfileState.success({
    required UserModel user,
    required UserTribes userTribes,
  }) = _Success;

  const factory UserProfileState.error(BaseApiError<dynamic> error) = _Error;
}
