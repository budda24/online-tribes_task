import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';

part 'user_tribes.freezed.dart';

@freezed
class UserTribes with _$UserTribes {
  const factory UserTribes({
    required List<TribeModel> ownedTribes,
    required List<TribeModel> memberTribes,
  }) = _UserTribes;
}
