import 'package:freezed_annotation/freezed_annotation.dart';

enum TribeMembershipTicketType {
  @JsonValue('INVITATION')
  invitation,
  @JsonValue('JOIN_REQUEST')
  joinRequest,
}

extension TribeMembershipTicketTypeExtension on TribeMembershipTicketType {
  String get value {
    const values = {
      TribeMembershipTicketType.invitation: 'INVITATION',
      TribeMembershipTicketType.joinRequest: 'JOIN_REQUEST',
    };
    return values[this]!;
  }
}
