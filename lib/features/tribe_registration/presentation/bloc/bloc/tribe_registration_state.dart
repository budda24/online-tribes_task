import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
part 'tribe_registration_state.freezed.dart';

@freezed
class TribeRegistrationState with _$TribeRegistrationState {
  const factory TribeRegistrationState.initial() = _Initial;
  const factory TribeRegistrationState.loading() = _RegistrationLoading;
  const factory TribeRegistrationState.tribeDataLoaded(TribeModel tribe) =
      _TribeDataLoaded;

  const factory TribeRegistrationState.submittingSuccess(
    TribeModel tribe,
  ) = _SubmittingSuccess;
  const factory TribeRegistrationState.failure(
    BaseApiError<dynamic> error,
  ) = _RegistrationFailure;
}
