import 'package:flutter/material.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/profiles/fake_post.dart';

class UserPostTab extends StatefulWidget {
  const UserPostTab({
    super.key,
  });
  @override
  State<UserPostTab> createState() => _UserPostTabState();
}

class _UserPostTabState extends State<UserPostTab> {
  @override
  Widget build(BuildContext context) {
    return const StyledSingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FakePosts(),
        ],
      ),
    );
  }
}
