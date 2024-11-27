import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_cubit.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_state.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tribe_membership_ticket_item.dart';

class TribeMembershipTicketsPage extends StatelessWidget {
  const TribeMembershipTicketsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: BlocBuilder<TribeProfileCubit, TribeProfileState>(
                builder: (context, state) => state.maybeMap(
                  loaded: (state) {
                    return Text(state.data.tribe.name);
                  },
                  orElse: () {
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
          const Header(),
          BlocBuilder<TribeProfileCubit, TribeProfileState>(
            builder: (context, state) => state.maybeMap(
              loaded: (state) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.data.pendingTickets[index];

                      return TribeMembershipTicketItem(
                        senderAvatarUrl: item.senderInfo.profilePictureUrl,
                        senderName: item.senderInfo.name,
                        message: item.message,
                        createdAt: item.createdAt,
                        status: item.status,
                        onAccept: () => context
                            .read<TribeProfileCubit>()
                            .onJoinRequestAccepted(item),
                        onDeny: () => context
                            .read<TribeProfileCubit>()
                            .onJoinRequestDenied(item),
                      );
                    },
                    childCount: state.data.pendingTickets.length,
                  ),
                );
              },
              orElse: () => const SliverToBoxAdapter(
                child: SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Text(
          context.localizations.requestsToTribe,
          style: context.appTextStyles.headline4.copyWith(
            color: context.appColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
