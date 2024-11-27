import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  factory UserInfo({
    required String id,
    required String name,
    required String profilePictureUrl,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  factory UserInfo.fromUserModel(UserModel userModel) {
    return UserInfo(
      id: userModel.userId!,
      name: userModel.username!,
      profilePictureUrl: userModel.information!.profilePictureUrl ?? '',
    );
  }
}
