import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class StyledKeyboardDismiss extends StatelessWidget {
  final Widget child;

  const StyledKeyboardDismiss({required this.child, super.key});
  @override
  Widget build(Object context) {
    return KeyboardDismissOnTap(
      child: child,
    );
  }
}
