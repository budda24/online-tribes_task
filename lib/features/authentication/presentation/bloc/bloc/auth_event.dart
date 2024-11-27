import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signOutRequested() = SignOutRequested;
  const factory AuthEvent.googleSignInRequested() = GoogleSignInRequested;
}
