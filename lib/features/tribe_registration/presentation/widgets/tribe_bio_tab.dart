import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/validation_utillity.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_registration_hints.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';

class TribeBioTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final TextEditingController bioController;
  final String? imageUrl;

  const TribeBioTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.bioController,
    required this.imageUrl,
    super.key,
  });

  @override
  State<TribeBioTab> createState() => _TribeBioTabState();
}

class _TribeBioTabState extends State<TribeBioTab> {
  @override
  void initState() {
    super.initState();

    widget.bioController.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.bioController.removeListener(_validateInput);

    super.dispose();
  }

  // Validate form inputs and enable/disable button
  void _validateInput() {
    final isValid = widget.bioController.text.length > 100;

    widget.onButtonStateChange(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return StyledRegistrationPadding(
      child: StyledKeyboardDismiss(
        child: StyledSingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 250.h,
                      child: StyledTextFormField(
                        showCharacterCounter: true,
                        maxLength: 650,
                        maxLines: 20,
                        hintText: context.localizations.bioNameHint,
                        validator: (value) => ValidationUtility.validateUserBio(
                          context,
                          value,
                        ),
                        controller: widget.bioController,
                      ),
                    ),
                    20.verticalSpace,
                    StyledRegistrationHints(
                      hints: [
                        context.localizations.tribeRegistrationBioHint1,
                        context.localizations.tribeRegistrationBioHint2,
                        context.localizations.tribeRegistrationBioHint3,
                        context.localizations.tribeRegistrationBioHint4,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
