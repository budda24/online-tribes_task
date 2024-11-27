import 'package:flutter/material.dart';

enum FreezedErrorReason { copyWithOnStateNotLoaded }

extension FreezedErrorReasonErrorMessage on FreezedErrorReason {
  String localizedMessage(BuildContext context) {
    switch (this) {
      case FreezedErrorReason.copyWithOnStateNotLoaded:
        return 'tried to use copy with on error that is not laded';
    }
  }
}
