import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.signedUpWithGoogle(UserModel user) =
      _SignedUpWithGoogle;
  const factory AuthState.loggedInWithGoogle(UserModel user) =
      _LoggedInWithGoogle;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.failure(BaseApiError<dynamic> error) = _Failure;
}
