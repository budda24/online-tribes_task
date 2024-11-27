import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/services/config_service.dart';
import 'package:online_tribes/features/shared/models/tribe_info.dart';
import 'package:online_tribes/features/shared/models/user_info.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/enum/tribe_membership_ticket_status.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_membership_ticket.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_membership_repository.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/enum/tribe_profile_visitor_status.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/tribe_profile_data.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_state.dart';

class TribeProfileCubit extends Cubit<TribeProfileState> {
  final TribeRepository _tribeRepository;
  final TribeMembershipRepository _tribeMembershipTicketsRepository;
  final UserRepository _userRepository;
  final ConfigService _configService;

  TribeProfileCubit(
    this._tribeRepository,
    this._tribeMembershipTicketsRepository,
    this._userRepository,
    this._configService,
  ) : super(const TribeProfileState.initial());

  Future<void> loadTribeData(String tribeId) async {
    emit(const TribeProfileState.loading());

    final getTribeResponse = await _tribeRepository.getTribe(tribeId);

    getTribeResponse.fold(
      (error) => emit(TribeProfileState.failure(error)),
      (tribe) async {
        final tribeGeneralRulesResponse =
            await _configService.fetchTribeGeneralRules();

        tribeGeneralRulesResponse.fold(
          (error) => emit(TribeProfileState.failure(error)),
          (tribeGeneralRules) async {
            final visitorStatus = _getVisitorStatus(tribe);

            switch (visitorStatus) {
              case TribeProfileVisitorStatus.isOwner:
                final pendingTicketsResponse =
                    await _tribeMembershipTicketsRepository
                        .findPendingTribeJoinRequests(tribeId);

                pendingTicketsResponse.fold(
                  (error) => emit(
                    TribeProfileState.failure(error),
                  ),
                  (pendingTickets) {
                    emit(
                      TribeProfileState.loaded(
                        TribeProfileData(
                          tribe: tribe,
                          visitorStatus: visitorStatus,
                          overallRules: tribeGeneralRules.overall,
                          pendingTickets: pendingTickets,
                        ),
                      ),
                    );
                  },
                );
                break;
              case TribeProfileVisitorStatus.isMember:
              case TribeProfileVisitorStatus.hasRequestPending:
              case TribeProfileVisitorStatus.joinRequestSent:
                emit(
                  TribeProfileState.loaded(
                    TribeProfileData(
                      tribe: tribe,
                      visitorStatus: visitorStatus,
                      overallRules: tribeGeneralRules.overall,
                    ),
                  ),
                );
                break;
              case TribeProfileVisitorStatus.isNotMember:
                final userPendingTicketsResponse =
                    await _tribeMembershipTicketsRepository
                        .findPendingTribeJoinRequestsForUser(
                  tribeId: tribeId,
                  userId: _userRepository.getUserId,
                );

                userPendingTicketsResponse.fold(
                  (error) => emit(TribeProfileState.failure(error)),
                  (pendingTickets) {
                    emit(
                      TribeProfileState.loaded(
                        TribeProfileData(
                          tribe: tribe,
                          visitorStatus: pendingTickets.isNotEmpty
                              ? TribeProfileVisitorStatus.hasRequestPending
                              : visitorStatus,
                          overallRules: tribeGeneralRules.overall,
                        ),
                      ),
                    );
                  },
                );
                break;
            }
          },
        );
      },
    );
  }

  Future<void> sendJoinRequest(String message) async {
    await state.maybeWhen(
      loaded: (tribeData) async {
        emit(const TribeProfileState.loading());

        final userResponse =
            await _userRepository.getUser(_userRepository.getUserId);

        userResponse.fold(
          (error) => emit(TribeProfileState.failure(error)),
          (user) async {
            final userJoinRequest = TribeMembershipTicket.newJoinRequest(
              tribeInfo: TribeInfo.fromTribeModel(tribeData.tribe),
              senderInfo: UserInfo.fromUserModel(user),
              message: message,
            );

            final joinRequestResponse = await _tribeMembershipTicketsRepository
                .sendJoinRequest(userJoinRequest);

            joinRequestResponse.fold(
              (error) => emit(TribeProfileState.failure(error)),
              (_) {
                emit(
                  TribeProfileState.loaded(
                    tribeData.copyWith(
                      visitorStatus: TribeProfileVisitorStatus.joinRequestSent,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      orElse: () {},
    );
  }

  Future<void> onJoinRequestAccepted(TribeMembershipTicket ticket) async {
    _updateTicketCandidate(
      ticket,
      status: TribeMembershipTicketStatus.inProgress,
    );

    final response = await _tribeMembershipTicketsRepository.acceptJoinRequest(
      ticketId: ticket.id!,
      tribeId: ticket.tribeInfo.id,
      userInfo: ticket.senderInfo,
    );

    response.fold(
      (error) => _updateTicketCandidate(
        ticket,
        status: TribeMembershipTicketStatus.pending,
      ),
      (success) => state.maybeWhen(
        loaded: (tribeData) {
          _updateTicketCandidate(
            ticket,
            status: TribeMembershipTicketStatus.accepted,
          );
        },
        orElse: () {},
      ),
    );
  }

  Future<void> onJoinRequestDenied(
    TribeMembershipTicket membershipTicket,
  ) async {
    _updateTicketCandidate(
      membershipTicket,
      status: TribeMembershipTicketStatus.inProgress,
    );

    final response = await _tribeMembershipTicketsRepository
        .denyJoinRequest(membershipTicket.id!);

    response.fold(
      (error) => _updateTicketCandidate(
        membershipTicket,
        status: TribeMembershipTicketStatus.pending,
      ),
      (success) => _updateTicketCandidate(
        membershipTicket,
        status: TribeMembershipTicketStatus.denied,
      ),
    );
  }

  void _updateTicketCandidate(
    TribeMembershipTicket membershipTicket, {
    required TribeMembershipTicketStatus status,
  }) {
    state.maybeWhen(
      loaded: (stateData) {
        final ticketCandidate = membershipTicket.copyWith(status: status);

        final updatedTickets = stateData.pendingTickets
            .map(
              (ticket) =>
                  ticket.id == membershipTicket.id ? ticketCandidate : ticket,
            )
            .where((ticket) => ticket.status.isActive)
            .toList();

        if (status == TribeMembershipTicketStatus.accepted) {
          final updatedMembers = <UserInfo>[];

          if (stateData.tribe.members != null) {
            updatedMembers.addAll(stateData.tribe.members!);
          }

          updatedMembers.add(membershipTicket.senderInfo);

          emit(
            TribeProfileState.loaded(
              stateData.copyWith(
                pendingTickets: updatedTickets,
                tribe: stateData.tribe.copyWith(members: updatedMembers),
              ),
            ),
          );
        } else {
          emit(
            TribeProfileState.loaded(
              stateData.copyWith(
                pendingTickets: updatedTickets,
              ),
            ),
          );
        }
      },
      orElse: () {},
    );
  }

  TribeProfileVisitorStatus _getVisitorStatus(TribeModel tribe) {
    final userId = _userRepository.getUserId;
    final ownerId = tribe.ownerId;
    final userIsMember = tribe.members?.contains(userId) ?? true;

    if (userId == ownerId) {
      return TribeProfileVisitorStatus.isOwner;
    } else if (userIsMember) {
      return TribeProfileVisitorStatus.isMember;
    } else {
      return TribeProfileVisitorStatus.isNotMember;
    }
  }
}
