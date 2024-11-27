import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_avatar.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_cubit.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_state.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_section_title.dart';

class TribeProfileMembersTab extends StatelessWidget {
  final TribeModel tribeModel;

  const TribeProfileMembersTab(this.tribeModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          12.verticalSpace,
          BlocBuilder<TribeProfileCubit, TribeProfileState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (data) {
                if (data.tribe.members == null || data.tribe.members!.isEmpty) {
                  return const NoMembersInfo();
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.tribe.members!.length,
                  itemBuilder: (context, index) {
                    final member = data.tribe.members![index];
                    return ListTile(
                      leading: RoundedAvatar(member.profilePictureUrl),
                      title: Text(
                        member.name,
                        style: context.appTextStyles.bodyText2,
                      ),
                    );
                  },
                );
              },
              orElse: () => const SizedBox(),
            ),
          ),
          4.verticalSpace,
        ],
      ),
    );
  }
}

class NoMembersInfo extends StatelessWidget {
  const NoMembersInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: TribeProfileSectionTitle(
        context.localizations.noMembersInfo,
      ),
    );
  }
}
