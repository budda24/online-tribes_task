import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/context_menu/presentation/widgets/user_status_card_context_menu.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';

class MembersTab extends StatelessWidget {
  final int itemCount;
  final List<String> imageUrls;
  final List<String> names;
  final List<String> joinedDates;
  final List<String> locations;
  final List<bool> statuses;

  const MembersTab({
    required this.itemCount,
    required this.imageUrls,
    required this.names,
    required this.joinedDates,
    required this.locations,
    required this.statuses,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StyledMainPadding.small(
      child: Column(
        children: [
          32.verticalSpace,
          Row(
            children: [
              Container(
                height: 55.h,
                width: 3.w,
                color: context.appColors.primaryColor,
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  context.localizations.membersHeadline,
                  style: context.appTextStyles.bodyText2,
                ),
              ),
            ],
          ),
          32.verticalSpace,
          if (itemCount > 0)
            Expanded(
              child: ListView.separated(
                itemCount: itemCount,
                separatorBuilder: (context, index) => 16.verticalSpace,
                itemBuilder: (context, index) {
                  return UserStatusCard(
                    imageUrl: imageUrls[index],
                    name: names[index],
                    status: statuses[index],
                    joinedDate: joinedDates[index],
                    location: locations[index],
                  );
                },
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
