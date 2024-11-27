import 'package:equatable/equatable.dart';

class BaseApiError<T> extends Equatable {
  final T reason;

  const BaseApiError({
    required this.reason,
  });

  factory BaseApiError.fromJson(
    Map<String, dynamic> json,
    T Function(String? json) fromJsonT,
  ) =>
      BaseApiError(
        reason: fromJsonT(json['reason'] as String?),
      );

  Map<String, dynamic> toJson(String Function(T value) toJsonT) {
    return {
      'reason': toJsonT(reason),
    };
  }

  @override
  List<Object?> get props => [
        reason,
      ];
}
