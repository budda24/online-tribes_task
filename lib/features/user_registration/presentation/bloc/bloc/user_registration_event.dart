import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';

part 'user_registration_event.freezed.dart';

@freezed
class UserRegistrationEvent with _$UserRegistrationEvent {
  const factory UserRegistrationEvent.showError(BaseApiError<dynamic> error) =
      _ShowError;
  // Define the SaveNameTabEvent
  const factory UserRegistrationEvent.saveNameTab({
    required String username,
    required String gender,
    required String myPlace,
    required File profilePictureFile,
  }) = _SaveNameTab;
  const factory UserRegistrationEvent.saveAgeTab({
    required List<String> languages,
    required double age,
  }) = _SaveAgeTab;
  const factory UserRegistrationEvent.saveBioTab({
    required String bio,
  }) = _SaveBioTab;
  const factory UserRegistrationEvent.saveHobbiesTab({
    required List<String> hobbies,
  }) = _SaveHobbiesTab;
  const factory UserRegistrationEvent.loadUserRegistrationData() =
      _LoadUserRegistrationData;

  const factory UserRegistrationEvent.initialEvent() = InitialEvent;
}
