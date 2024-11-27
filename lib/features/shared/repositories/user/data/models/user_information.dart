import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information.freezed.dart';
part 'user_information.g.dart';

@freezed
class UserInformation with _$UserInformation {
  factory UserInformation({
    List<String>? languages,
    List<String>? hobbies,
    double? age,
    String? bio,
    String? gender,
    String? myPlace,
    String? profilePictureUrl,
  }) = _UserInformation;

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);

  // Define field names as constants
  static const String fieldLanguages = 'languages';
  static const String fieldHobbies = 'hobbies';
  static const String fieldAge = 'age';
  static const String fieldBio = 'bio';
  static const String fieldGender = 'gender';
  static const String fieldMyPlace = 'myPlace';
  static const String fieldProfilePictureUrl = 'profilePictureUrl';

  // New factory constructor
  factory UserInformation.empty() {
    return UserInformation(
      hobbies: [],
      languages: [],
    );
  }
}
