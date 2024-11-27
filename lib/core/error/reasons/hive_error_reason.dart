import 'package:flutter/widgets.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum HiveErrorReason {
  boxNotFound,
  invalidBox,
  boxAlreadyOpen,
  keyNotFound,
  corruptBox,
  readError,
  writeError,
  deleteError,
  typeError,
  unknownError,
}

extension HiveErrorReasonMessageExtension on HiveErrorReason {
  String localizedMessage(BuildContext context) {
    final localizations =
        context.localizations; // Assume you have localization support set up.

    switch (this) {
      case HiveErrorReason.boxNotFound:
        return localizations.boxNotFoundError;
      case HiveErrorReason.invalidBox:
        return localizations.invalidBoxError;
      case HiveErrorReason.boxAlreadyOpen:
        return localizations.boxAlreadyOpenError;
      case HiveErrorReason.keyNotFound:
        return localizations.keyNotFoundError;
      case HiveErrorReason.corruptBox:
        return localizations.corruptBoxError;
      case HiveErrorReason.readError:
        return localizations.readError;
      case HiveErrorReason.writeError:
        return localizations.writeError;
      case HiveErrorReason.deleteError:
        return localizations.deleteError;
      case HiveErrorReason.typeError:
        return localizations.typeErrorError;

      case HiveErrorReason.unknownError:
        return localizations.unknownError;
    }
  }
}
