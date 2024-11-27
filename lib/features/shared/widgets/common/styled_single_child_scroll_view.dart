import 'package:flutter/material.dart';

class StyledSingleChildScrollView extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget child;
  final bool isKeyboardDismissOnDrag;

  const StyledSingleChildScrollView({
    required this.child,
    super.key,
    this.scrollController,
    this.isKeyboardDismissOnDrag = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      keyboardDismissBehavior: isKeyboardDismissOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 100,
      ),
      child: child,
    );
  }
}
