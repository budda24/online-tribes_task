import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingPlaceholder extends StatefulWidget {
  final String localAssetName;
  final double? width;

  const BlinkingPlaceholder({
    required this.localAssetName,
    this.width,
    super.key,
  });

  @override
  BlinkingPlaceholderState createState() => BlinkingPlaceholderState();
}

class BlinkingPlaceholderState extends State<BlinkingPlaceholder> {
  bool blink = true;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 550), (_) {
      setState(() => blink = !blink);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: blink ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 550),
      child: Image.asset(
        widget.localAssetName,
        width: widget.width ?? double.infinity,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
