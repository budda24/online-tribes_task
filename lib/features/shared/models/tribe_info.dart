import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';

part 'tribe_info.freezed.dart';
part 'tribe_info.g.dart';

@freezed
class TribeInfo with _$TribeInfo {
  factory TribeInfo({
    required String id,
    required String name,
  }) = _TribeInfo;

  factory TribeInfo.fromJson(Map<String, dynamic> json) =>
      _$TribeInfoFromJson(json);

  factory TribeInfo.fromTribeModel(TribeModel tribeModel) {
    return TribeInfo(
      id: tribeModel.tribeId,
      name: tribeModel.name,
    );
  }
}
