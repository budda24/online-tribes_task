import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/utils/json_converters.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_activity.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_information.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

// Main UserModel
@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required int lastRegistrationStepIndex,
    String? userId,
    String? email,
    String? username,
    UserInformation? information,
    UserActivity? userActivity,
    @TimestampConverter() DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Define field names as constants
  static const String fieldUserId = 'userId';
  static const String fieldEmail = 'email';
  static const String fieldUsername = 'username';
  static const String fieldLastRegistrationStepIndex =
      'lastRegistrationStepIndex';
  static const String fieldInformation = 'information';
  static const String fieldUserActivity = 'userActivity';
  static const String fieldEngagementMetrics = 'engagementMetrics';

  // New factory constructor
  factory UserModel.empty() {
    return UserModel(
      lastRegistrationStepIndex: 0,
      information: UserInformation.empty(),
      userActivity: UserActivity.empty(),
    );
  }
}

// Extension for updating UserModel's information
extension UserModelExtensions on UserModel {
  UserModel updateInformation(
    UserInformation Function(UserInformation) updates,
  ) {
    return copyWith(
      information: updates(information ?? UserInformation()),
    );
  }
}
