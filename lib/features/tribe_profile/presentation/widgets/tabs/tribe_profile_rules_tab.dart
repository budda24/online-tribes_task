import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_section_title.dart';

class TribeProfileRulesTab extends StatelessWidget {
  final List<String> tribeOverallRules;

  const TribeProfileRulesTab(
    this.tribeOverallRules, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          8.verticalSpace,
          TribeProfileSectionTitle(context.localizations.overallRules),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tribeOverallRules.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 12.r,
                  child: Text(
                    '${index + 1}',
                  ),
                ),
                title: Text(
                  tribeOverallRules[index],
                  style: context.appTextStyles.bodyText2,
                ),
              );
            },
          ),
          4.verticalSpace,
        ],
      ),
    );
  }
}
