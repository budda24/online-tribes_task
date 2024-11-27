import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledDivider extends StatelessWidget {
  const StyledDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Divider(
        color: context.appColors.dividerColor,
        height: 4,
        thickness: 2,
      ),
    );
  }
}
