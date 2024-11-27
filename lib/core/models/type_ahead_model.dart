import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_ahead_model.freezed.dart';
part 'type_ahead_model.g.dart';

@freezed
class TypeAheadModel with _$TypeAheadModel {
  const factory TypeAheadModel({
    required List<String> values,
  }) = _TypeAheadModel;

  factory TypeAheadModel.fromJson(Map<String, dynamic> json) =>
      _$TypeAheadModelFromJson(json);
}
