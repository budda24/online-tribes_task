import 'package:flutter/material.dart';

class StyledRegistrationPadding extends StatelessWidget {
  final Widget child;
  const StyledRegistrationPadding({
    required this.child,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        16,
      ),
      child: child,
    );
  }
}
