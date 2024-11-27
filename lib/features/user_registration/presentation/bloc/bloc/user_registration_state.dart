import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';

part 'user_registration_state.freezed.dart';

@freezed
abstract class UserRegistrationState with _$UserRegistrationState {
  const factory UserRegistrationState.initial() = Initial;
  const factory UserRegistrationState.loading() = RegistrationLoading;
  const factory UserRegistrationState.submittingSuccess(
    UserModel user,
  ) = SubmittingSuccess;
  const factory UserRegistrationState.userDataLoaded(UserModel user) =
      _UserDataLoaded;
  const factory UserRegistrationState.failure(
    BaseApiError<dynamic> error,
  ) = RegistrationFailure;
}
