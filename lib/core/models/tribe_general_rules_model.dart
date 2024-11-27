import 'package:freezed_annotation/freezed_annotation.dart';

part 'tribe_general_rules_model.freezed.dart';
part 'tribe_general_rules_model.g.dart';

@freezed
class TribeGeneralRulesModel with _$TribeGeneralRulesModel {
  const factory TribeGeneralRulesModel({
    required List<String> overall,
  }) = _TribeGeneralRulesModel;

  factory TribeGeneralRulesModel.fromJson(Map<String, dynamic> json) =>
      _$TribeGeneralRulesModelFromJson(json);
}
