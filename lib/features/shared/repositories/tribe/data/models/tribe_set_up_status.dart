import 'package:freezed_annotation/freezed_annotation.dart';

part 'tribe_set_up_status.g.dart';
part 'tribe_set_up_status.freezed.dart';

@freezed
class TribeSetUpStatus with _$TribeSetUpStatus {
  const factory TribeSetUpStatus({
    required bool isInviteThreePeopleFinished,
    required bool isWriteFirstPostFinished,
    required bool isUploadBannerImageFinished,
    required bool isFullDescriptionFinished,
    required bool isAddRulesFinished,
  }) = _TribeSetUpStatus;
  const TribeSetUpStatus._();

  factory TribeSetUpStatus.fromJson(Map<String, dynamic> json) =>
      _$TribeSetUpStatusFromJson(json);

  bool get isFinished =>
      isInviteThreePeopleFinished &&
      isWriteFirstPostFinished &&
      isUploadBannerImageFinished &&
      isFullDescriptionFinished &&
      isAddRulesFinished;
}
