import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class Helpers {
  static String getTimeDifferenceFromNow(
    DateTime dateTime, {
    required BuildContext context,
  }) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${context.localizations.minutesShort}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${context.localizations.hoursShort}';
    } else {
      return '${difference.inDays} ${context.localizations.daysShort}';
    }
  }
}
