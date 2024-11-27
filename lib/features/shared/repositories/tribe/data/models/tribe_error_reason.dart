import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum TribeErrorReason {
  tribeNameExist,
  creatingTribeFailed,
  unknownError,
  tribeNotLoaded
}

extension TribeErrorReasonMessageExtension on TribeErrorReason {
  String localizedMessage(BuildContext context) {
    switch (this) {
      case TribeErrorReason.tribeNameExist:
        return context.localizations.tribeNameExist;
      case TribeErrorReason.creatingTribeFailed:
        return context.localizations.creatingTribeFailed;
      case TribeErrorReason.unknownError:
        return context.localizations.unknownError;
      case TribeErrorReason.tribeNotLoaded:
        return context.localizations.tribeNotLoadedError;
    }
  }
}
