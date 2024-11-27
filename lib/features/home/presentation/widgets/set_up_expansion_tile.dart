// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/home/presentation/cubit/home_page_cubit.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_set_up_status.dart';

enum TribeSetUpStep {
  inviteThreePeople,
  writeFirstPost,
  uploadBannerImage,
  fillDescription,
  addRules,
}

class SetUpExpansionTile extends StatefulWidget {
  final TribeSetUpStatus tribeSetUpStatus;

  const SetUpExpansionTile({
    required this.tribeSetUpStatus,
    super.key,
  });

  @override
  State<SetUpExpansionTile> createState() => _SetUpExpansionTileState();
}

class _SetUpExpansionTileState extends State<SetUpExpansionTile> {
  static const double _progressIndicatorSize = 24;
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);

  double _calculateProgress() {
    final totalItems = widget.tribeSetUpStatus.toJson().values.length;
    final completedSteps = widget.tribeSetUpStatus
        .toJson()
        .values
        .where((value) => value == true)
        .length;
    return completedSteps / totalItems;
  }

  void _toggleStep(TribeSetUpStep step) {
    final homePageCubit = context.read<HomePageCubit>();
    final currentStatus = widget.tribeSetUpStatus;
    TribeSetUpStatus updatedStatus;

    switch (step) {
      case TribeSetUpStep.inviteThreePeople:
        // TODO(franio): navigation that will return bool on pop, then we call updateTribeSetUpStatus
        updatedStatus = currentStatus.copyWith(
          isInviteThreePeopleFinished: true,
        );
        homePageCubit.updateTribeSetUpStatus(updatedStatus);
        break;
      case TribeSetUpStep.writeFirstPost:
        // TODO(franio): navigation that will return bool on pop, then we call updateTribeSetUpStatus
        updatedStatus = currentStatus.copyWith(
          isWriteFirstPostFinished: true,
        );
        homePageCubit.updateTribeSetUpStatus(updatedStatus);
        break;
      case TribeSetUpStep.uploadBannerImage:
        // TODO(franio): navigation that will return bool on pop, then we call updateTribeSetUpStatus
        updatedStatus = currentStatus.copyWith(
          isUploadBannerImageFinished: true,
        );
        homePageCubit.updateTribeSetUpStatus(updatedStatus);
        break;
      case TribeSetUpStep.fillDescription:
        // TODO(franio): navigation that will return bool on pop, then we call updateTribeSetUpStatus
        updatedStatus = currentStatus.copyWith(
          isFullDescriptionFinished: true,
        );
        homePageCubit.updateTribeSetUpStatus(updatedStatus);
        break;
      case TribeSetUpStep.addRules:
        // TODO(franio): navigation that will return bool on pop, then we call updateTribeSetUpStatus
        updatedStatus = currentStatus.copyWith(
          isAddRulesFinished: true,
        );
        homePageCubit.updateTribeSetUpStatus(updatedStatus);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isExpanded,
        builder: (context, isExpanded, child) {
          return Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.shadowColor.withOpacity(0.4),
                      blurRadius: isExpanded ? 2 : 1,
                      offset: Offset(0, isExpanded ? 2 : 1),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  backgroundColor: context.appColors.dropdownListColor,
                  collapsedBackgroundColor: context.appColors.dropdownListColor,
                  onExpansionChanged: (expanded) {
                    _isExpanded.value = expanded;
                  },
                  title: Text(
                    context.localizations.setUpYourTribe,
                    style: context.appTextStyles.bodyText2,
                  ),
                  leading: Stack(
                    children: [
                      SizedBox.square(
                        dimension: _progressIndicatorSize,
                        child: CircularProgressIndicator(
                          value: 1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.appColors.disabledColor,
                          ),
                          strokeWidth: 6,
                        ),
                      ),
                      SizedBox.square(
                        dimension: _progressIndicatorSize,
                        child: CircularProgressIndicator(
                          value: _calculateProgress(),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.appColors.primaryColor,
                          ),
                          strokeWidth: 6,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Divider(
                      color: context.appColors.dropdownDividerColor,
                      thickness: 1,
                    ),
                    SetUpTile(
                      context: context,
                      title: context.localizations.inviteThreePeople,
                      isChecked:
                          widget.tribeSetUpStatus.isInviteThreePeopleFinished,
                      onTap: () =>
                          _toggleStep(TribeSetUpStep.inviteThreePeople),
                    ),
                    SetUpTile(
                      context: context,
                      title: context.localizations.writeYourFirstPost,
                      isChecked:
                          widget.tribeSetUpStatus.isWriteFirstPostFinished,
                      onTap: () => _toggleStep(TribeSetUpStep.writeFirstPost),
                    ),
                    SetUpTile(
                      context: context,
                      title: context.localizations.uploadBannerImage,
                      isChecked:
                          widget.tribeSetUpStatus.isUploadBannerImageFinished,
                      onTap: () =>
                          _toggleStep(TribeSetUpStep.uploadBannerImage),
                    ),
                    SetUpTile(
                      context: context,
                      title: context.localizations.fillShortDescription,
                      isChecked:
                          widget.tribeSetUpStatus.isFullDescriptionFinished,
                      onTap: () => _toggleStep(TribeSetUpStep.fillDescription),
                    ),
                    SetUpTile(
                      context: context,
                      title: context.localizations.addRules,
                      isChecked: widget.tribeSetUpStatus.isAddRulesFinished,
                      onTap: () => _toggleStep(TribeSetUpStep.addRules),
                    ),
                    // Add padding to text
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Text(
                        context.localizations.fillOutTheList,
                        style: context.appTextStyles.bodyText2.copyWith(
                          color: context.appColors.redColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SetUpTile extends StatelessWidget {
  final BuildContext context;
  final String title;
  final bool isChecked;
  final VoidCallback onTap;
  const SetUpTile({
    required this.context,
    required this.title,
    required this.isChecked,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: context.appTextStyles.bodyText2,
      ),
      leading: isChecked
          ? Icon(
              Icons.check_circle_rounded,
              size: 30,
              color: context.appColors.primaryColor,
            )
          : Icon(
              Icons.radio_button_unchecked_outlined,
              size: 30,
              color: context.appColors.disabledColor,
            ),
    );
  }
}
