import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/features/shared/models/user_info.dart';

part 'tribe_suggestion_model.g.dart';
part 'tribe_suggestion_model.freezed.dart';

@freezed
class TribeSuggestionModel with _$TribeSuggestionModel {
  const factory TribeSuggestionModel({
    required String name,
    required String tribeId,
    required String bio,
    required List<UserInfo> members,
    required String signUrl,
    required String ownerName,
  }) = _TribeSuggestionModel;

  factory TribeSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$TribeSuggestionModelFromJson(json);
}
