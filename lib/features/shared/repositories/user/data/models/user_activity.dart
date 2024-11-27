import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activity.freezed.dart';
part 'user_activity.g.dart';

@freezed
class UserActivity with _$UserActivity {
  factory UserActivity({
    List<String>? notifications,
    DateTime? lastTimeActive,
    DateTime? profileCreatedAt,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);

  // Define field names as constants
  static const String fieldNotifications = 'notifications';
  static const String fieldLastTimeActive = 'lastTimeActive';
  static const String fieldProfileCreatedAt = 'profileCreatedAt';

  factory UserActivity.empty() {
    return UserActivity(
      notifications: [],
    );
  }
}
