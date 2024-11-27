import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_membership_ticket.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/enum/tribe_profile_visitor_status.dart';

class TribeProfileData {
  final TribeModel tribe;
  final TribeProfileVisitorStatus visitorStatus;
  final List<String> overallRules;
  final List<TribeMembershipTicket> pendingTickets;

  TribeProfileData({
    required this.tribe,
    required this.visitorStatus,
    required this.overallRules,
    this.pendingTickets = const [],
  });

  TribeProfileData copyWith({
    TribeModel? tribe,
    TribeProfileVisitorStatus? visitorStatus,
    List<String>? overallRules,
    List<TribeMembershipTicket>? pendingTickets,
  }) {
    return TribeProfileData(
      tribe: tribe ?? this.tribe,
      visitorStatus: visitorStatus ?? this.visitorStatus,
      overallRules: overallRules != null
          ? List<String>.from(overallRules)
          : List<String>.from(this.overallRules),
      pendingTickets: pendingTickets != null
          ? List<TribeMembershipTicket>.from(pendingTickets)
          : List<TribeMembershipTicket>.from(this.pendingTickets),
    );
  }
}
