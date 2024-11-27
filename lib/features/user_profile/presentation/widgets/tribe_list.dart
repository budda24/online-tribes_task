import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/extensions/string_extensions.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class TribeList extends StatelessWidget {
  final List<TribeModel> tribes;
  final String emptyMessage;

  const TribeList({
    required this.tribes,
    required this.emptyMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (tribes.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Text(
          emptyMessage,
          style: context.appTextStyles.bodyText2,
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tribes.length,
      separatorBuilder: (context, index) => Divider(height: 20.h),
      itemBuilder: (context, index) {
        final tribe = tribes[index];
        return TribeListItem(tribe: tribe);
      },
    );
  }
}

class TribeListItem extends StatelessWidget {
  final TribeModel tribe;

  const TribeListItem({
    required this.tribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: tribe.signUrl != null
                ? CachedNetworkImageProvider(tribe.signUrl!)
                : Assets.shared.logo as ImageProvider,
          ),
          title: Text(
            tribe.name,
            style: textStyles.subtitle1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tribe.members?.length ?? 0} members',
                style: textStyles.overline,
              ),
              SizedBox(height: 5.h),
            ],
          ),
          onTap: () {
            // Implement navigation to tribe details if needed.
          },
        ),
        Text(
          tribe.bio?.limitToTwoSentences() ?? 'No Bio available.',
          style: textStyles.bodyText2,
        ),
      ],
    );
  }
}
