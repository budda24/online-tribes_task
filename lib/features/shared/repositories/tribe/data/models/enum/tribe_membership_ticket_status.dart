import 'package:freezed_annotation/freezed_annotation.dart';

enum TribeMembershipTicketStatus {
  @JsonValue('ACCEPTED')
  accepted,
  @JsonValue('PENDING')
  pending,
  @JsonValue('DENIED')
  denied,
  @JsonValue('IN_PROGRESS')
  inProgress;

  bool get isActive =>
      this == TribeMembershipTicketStatus.inProgress ||
      this == TribeMembershipTicketStatus.pending;
}

extension TribeMembershipTicketStatusExtension on TribeMembershipTicketStatus {
  String get value {
    switch (this) {
      case TribeMembershipTicketStatus.accepted:
        return 'ACCEPTED';
      case TribeMembershipTicketStatus.pending:
        return 'PENDING';
      case TribeMembershipTicketStatus.denied:
        return 'DENIED';
      case TribeMembershipTicketStatus.inProgress:
        return 'IN_PROGRESS';
    }
  }
}
