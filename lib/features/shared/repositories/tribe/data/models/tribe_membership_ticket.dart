// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/utils/json_converters.dart';
import 'package:online_tribes/features/shared/models/tribe_info.dart';
import 'package:online_tribes/features/shared/models/user_info.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/enum/tribe_membership_ticket_status.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/enum/tribe_membership_ticket_type.dart';

part 'tribe_membership_ticket.freezed.dart';
part 'tribe_membership_ticket.g.dart';

@freezed
class TribeMembershipTicket with _$TribeMembershipTicket {
  factory TribeMembershipTicket({
    required TribeInfo tribeInfo,
    required UserInfo senderInfo,
    required TribeMembershipTicketType type,
    required TribeMembershipTicketStatus status,
    required String message,
    @NonNullTimestampConverter() required DateTime createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
  }) = _TribeMembershipTicket;

  factory TribeMembershipTicket.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return TribeMembershipTicket.fromJson(data).copyWith(id: doc.id);
  }

  /// Be careful when use it, it will not include the id of the tribe. Use [TribeMembershipTicket.fromDoc] instead
  factory TribeMembershipTicket.fromJson(Map<String, dynamic> json) =>
      _$TribeMembershipTicketFromJson(json);

  factory TribeMembershipTicket.newJoinRequest({
    required String message,
    required TribeInfo tribeInfo,
    required UserInfo senderInfo,
  }) =>
      TribeMembershipTicket(
        tribeInfo: tribeInfo,
        senderInfo: senderInfo,
        type: TribeMembershipTicketType.joinRequest,
        status: TribeMembershipTicketStatus.pending,
        message: message,
        createdAt: DateTime.now(),
      );
}
