import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum UserErrorReason {
  userNameExist,
  cantGetUser,
  invalidUserName,
}

extension UserErrorReasonMessageExtension on UserErrorReason {
  String localizedMessage(BuildContext context) {
    switch (this) {
      case UserErrorReason.userNameExist:
        return context.localizations.userNameExist;
      case UserErrorReason.cantGetUser:
        return context.localizations.cantGetUser;
      case UserErrorReason.invalidUserName:
        return '';
    }
  }
}
