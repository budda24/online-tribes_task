import 'package:flutter/material.dart';

class AppWidgetStyles {
  BoxShadow get dropShadow => BoxShadow(
        color: Colors.black.withOpacity(0.25), // 25% opacity
        offset: const Offset(0, 1), // X: 0, Y: 1
        blurRadius: 1, // Blur radius of 1
      );
  BoxShadow customColorDropShadow(Color color) => BoxShadow(
        color: color.withOpacity(0.3),

        offset: const Offset(0, 3), // X: 0, Y: 1
        spreadRadius: 1,

        blurRadius: 5, // Blur radius of 1
      );
}
