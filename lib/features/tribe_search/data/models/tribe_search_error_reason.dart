import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum TribeSearchErrorReason {
  unknown,
}

extension TribeSearchErrorReasonExtension on TribeSearchErrorReason {
  String localizedMessage(BuildContext context) {
    final localizations = context.localizations;

    switch (this) {
      case TribeSearchErrorReason.unknown:
        return localizations.unknownError;
    }
  }
}
