import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/utils/json_converters.dart';
import 'package:online_tribes/features/shared/models/user_info.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_set_up_status.dart';
import 'package:online_tribes/features/tribe_registration/domain/entities/tribe_registration_step.dart';

part 'tribe_model.freezed.dart';
part 'tribe_model.g.dart';

@freezed
class TribeModel with _$TribeModel {
  factory TribeModel({
    required String name,
    required String tribeId,
    int? lastTribeRegistrationStepIndex,
    String? language,
    String? signUrl,
    String? bio,
    String? type,
    List<String>? themes,
    String? ownerId,
    List<UserInfo>? members,
    List<String>? pinnedPostsId,
    String? membershipCriteria,
    @TimestampConverter() DateTime? createdAt,
    String? ownerName,
    @Default(
      TribeSetUpStatus(
        isInviteThreePeopleFinished: false,
        isWriteFirstPostFinished: false,
        isUploadBannerImageFinished: false,
        isFullDescriptionFinished: false,
        isAddRulesFinished: false,
      ),
    )
    TribeSetUpStatus tribeSetUpStatus,
  }) = _TribeModel;

  factory TribeModel.fromJson(Map<String, dynamic> json) =>
      _$TribeModelFromJson(json);

  // Named constructor to create an empty TribeModel instance
  factory TribeModel.empty() => TribeModel(
        name: '',
        tribeId: '',
        lastTribeRegistrationStepIndex: TribeRegistrationStep.name.index,
        themes: [],
        members: [],
        pinnedPostsId: [],
      );

  static const String fieldName = 'name';
  static const String fieldSignUrl = 'signUrl';
  static const String fieldLanguage = 'language';
  static const String fieldDescription = 'bio';
  static const String fieldType = 'type';
  static const String fieldThemes = 'themes';
  static const String fieldOwnerId = 'ownerId';
  static const String fieldMembers = 'members';
  static const String fieldPinnedPostsId = 'pinnedPostsId';
  static const String fieldMembershipCriteria = 'membershipCriteria';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldLastRegistrationStepIndex =
      'lastTribeRegistrationStepIndex';
}
