import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_section_title.dart';

class TribeProfileAboutTab extends StatelessWidget {
  final TribeModel tribeModel;

  const TribeProfileAboutTab(this.tribeModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          8.verticalSpace,
          TribeProfileSectionTitle(
            context.localizations.whoWeAre,
          ),
          4.verticalSpace,
          Text(
            tribeModel.bio ?? '',
            style: context.appTextStyles.bodyText2,
          ),
          16.verticalSpace,
          ThemesGrid(tribeModel.themes ?? []),
        ],
      ),
    );
  }
}

class ThemesGrid extends StatelessWidget {
  final List<String> themes;

  const ThemesGrid(this.themes, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 6.h,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final item = themes[index];

        return Card(
          elevation: 2,
          color: context.appColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              item,
              style: context.appTextStyles.bodyText2.copyWith(
                fontSize: 12.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
