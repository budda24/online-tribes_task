import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart'; // Assuming context extensions are used for localization

class ValidationUtility {
  static String? validatePassword(BuildContext context, String? value) {
    // Check if the value is null or empty
    if (value == null || value.isEmpty) {
      return context.localizations.passwordRequired;
    }
    // Check if the password length is less than 8 characters
    else if (value.length < 8) {
      return context.localizations.passwordMinLength;
    }
    // Check if the password contains at least one uppercase letter
    else if (!RegExp('^(?=.*[A-Z])').hasMatch(value)) {
      return context.localizations.passwordUppercase;
    }
    // Check if the password contains at least one lowercase letter
    else if (!RegExp('^(?=.*[a-z])').hasMatch(value)) {
      return context.localizations.passwordLowercase;
    }
    // Check if the password contains at least one digit
    else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
      return context.localizations.passwordDigit;
    }
    // Check if the password contains at least one special character from the set !@#$%^&*
    else if (!RegExp(r'^(?=.*[!@#\$%^&*])').hasMatch(value)) {
      return context.localizations.passwordSpecialCharacter;
    }
    // If all conditions are met, the password is valid
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.emailRequired;
    } else if (!RegExp(r'^[a-z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return context.localizations.emailInvalid;
    }
    return null;
  }

  static String? validateUsername(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.userNameRequired;
    } else if (value.length <= 3) {
      return context.localizations.userNameMinLength;
    }
    // Check if the username contains only lowercase letters and digits
    else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return context.localizations.userNameInvalidCharacters;
    }
    return null;
  }

  static String? validateTribeName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.tribeNameExist;
    } else if (value.length <= 3) {
      return context.localizations.tribeNameMinLength;
    }
    // Check if the username contains only lowercase letters and digits
    else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return context.localizations.tribeNameInvalidCharacters;
    }
    return null;
  }

  static String? validateUserBio(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.bioRequired;
    } else if (value.trim().length < 100) {
      return context
          .localizations.bioMinLength; // Bio must be at least 100 characters
    }
    return null;
  }

  static String? validateTribeBio(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.bioRequired;
    } else if (value.trim().length < 100) {
      return context
          .localizations.bioMinLength; // Bio must be at least 100 characters
    }
    return null;
  }

  static String? validateCriteria(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.tribeCriteriaRequired;
    } else if (value.trim().length < 50) {
      return context.localizations
          .tribeCriteriaMinLength; // Criteria must be at least 50 characters
    }
    return null;
  }
}
