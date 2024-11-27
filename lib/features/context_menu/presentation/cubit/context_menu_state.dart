import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';

part 'context_menu_state.freezed.dart';

@freezed
abstract class ContextMenuState with _$ContextMenuState {
  const factory ContextMenuState.initial() = _Initial;

  const factory ContextMenuState.loading() = _Loading;

  const factory ContextMenuState.loaded({
    required TribeModel tribe,
  }) = _Loaded;

  const factory ContextMenuState.error(
    BaseApiError<dynamic> error,
  ) = _Error;
}
