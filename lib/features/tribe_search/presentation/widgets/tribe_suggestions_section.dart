import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/widgets/common/blinking_placeholder.dart';
import 'package:online_tribes/features/tribe_search/domain/models/tribe_suggestion_model.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/router/app_routes.dart';

class TribeSuggestionsSection extends StatelessWidget {
  final String searchPhraseSelected;
  final List<TribeSuggestionModel> tribeSuggestions;

  const TribeSuggestionsSection({
    required this.searchPhraseSelected,
    required this.tribeSuggestions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
          child: Text(
            searchPhraseSelected,
            style: context.appTextStyles.subtitle2BOld,
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tribeSuggestions.length,
          itemBuilder: (context, index) {
            final item = tribeSuggestions[index];

            return TribeSuggestionItem(
              item,
              onTap: () =>
                  TribeProfileRoute(tribeId: item.tribeId).push<void>(context),
            );
          },
        ),
      ],
    );
  }
}

class TribeSuggestionItem extends StatelessWidget {
  final TribeSuggestionModel item;
  final VoidCallback onTap;

  const TribeSuggestionItem(
    this.item, {
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.appColors.primaryColorLight.withOpacity(0.2),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            height: 110.h,
            imageUrl: item.signUrl,
            placeholder: (context, value) => BlinkingPlaceholder(
              localAssetName: Assets.shared.logo.logoSquer.path,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                16.verticalSpace,
                Text(
                  item.name,
                  style: context.appTextStyles.bodyText2
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                16.verticalSpace,
                Text(
                  item.bio,
                  style: context.appTextStyles.bodyText2,
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Text(
                      '${item.members.length} ${context.localizations.members.toLowerCase()}',
                      style: context.appTextStyles.bodyText2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    6.horizontalSpace,
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.black,
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: Text(
                        item.ownerName,
                        style: context.appTextStyles.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
