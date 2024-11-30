import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';

part 'home_page_state.freezed.dart';

@freezed
abstract class HomePageState with _$HomePageState {
  const factory HomePageState.initial() = _Initial;

  const factory HomePageState.loading() = _Loading;

  const factory HomePageState.loaded({
    required TribeModel tribe,
    required UserModel user,
    required String stateId,
  }) = Loaded;

  const factory HomePageState.error(
    BaseApiError<dynamic> error,
  ) = _Error;
}
