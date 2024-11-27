import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/extensions/string_extensions.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';

class TribeDialog extends StatefulWidget {
  final TextEditingController requestMessageController;
  final Future Function(String) onSendPressed;

  const TribeDialog({
    required this.requestMessageController,
    required this.onSendPressed,
    super.key,
  });

  @override
  State<TribeDialog> createState() => _TribeDialogState();
}

class _TribeDialogState extends State<TribeDialog> {
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  static const int _minimumMessageLength = 5;

  @override
  void initState() {
    super.initState();
    widget.requestMessageController.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.requestMessageController.removeListener(
      _validateInput,
    );
    super.dispose();
  }

  void _validateInput() {
    final isValid =
        widget.requestMessageController.text.length > _minimumMessageLength;

    _onNameTabButtonStateChange(isValid);
  }

  void _onNameTabButtonStateChange(bool isEnabled) {
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: StyledMainPadding.dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.localizations.requestMembership,
              style: context.appTextStyles.headline4,
            ),
            16.verticalSpace,
            StyledTextFormField(
              showCharacterCounter: true,
              maxLength: 50,
              maxLines: 5,
              hintText: context.localizations.writeSomething,
              controller: widget.requestMessageController,
            ),
            32.verticalSpace,
            if (_isButtonEnabled)
              StyledFilledButton.sharp(
                onPressed: () async {
                  setState(() => _isLoading = true);
                  final message = widget.requestMessageController.text;
                  try {
                    await widget.onSendPressed(message.sanitizedForFirebase);
                    if (!context.mounted) return;
                    context.router.pop();
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
                buttonText: _isLoading
                    ? context.localizations.sending
                    : context.localizations.send,
              )
            else
              StyledFilledButton.disabledSharp(
                buttonText: context.localizations.send,
              ),
            32.verticalSpace,
            TextButton(
              onPressed: () => context.router.pop(),
              child: Text(
                context.localizations.cancel,
                style: context.appTextStyles.bodyText1.copyWith(
                  color: context.appColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
