import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final int maxLength; // Add maxLength property
  final bool showCharacterCounter;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final TextInputType? textInputType;

  const StyledTextFormField({
    required this.hintText,
    required this.controller,
    required this.maxLength,
    this.validator,
    this.textInputType,
    this.showCharacterCounter = false,
    this.maxLines = 1,
    super.key,
    this.obscureText = false,
    this.onChanged,
    this.focusNode,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.secondaryColor,
        borderRadius: BorderRadius.circular(
          5,
        ),
        boxShadow: [
          context.appWidgetStyles.dropShadow,
        ],
      ),
      child: TextFormField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        obscureText: obscureText,
        onChanged: onChanged,
        maxLines: maxLines,
        maxLength: maxLength, // Add maxLength to TextFormField
        keyboardType: textInputType ??
            (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
        decoration: InputDecoration(
          suffix: suffixIcon,
          hintText: hintText,
          hintStyle: context.appTextStyles.subtitle2
              .copyWith(color: context.appColors.disabledColor),
          counterText: showCharacterCounter ? null : '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
