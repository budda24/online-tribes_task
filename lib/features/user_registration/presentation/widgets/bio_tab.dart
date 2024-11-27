// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/validation_utillity.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_registration_hints.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';

class BioTab extends StatefulWidget {
  final String? imageUrl;
  final GlobalKey<FormState> formKey;
  final TextEditingController bioController;
  final ValueChanged<bool> onButtonStateChange;
  final ScrollController scrollController;

  const BioTab({
    required this.formKey,
    required this.bioController,
    required this.onButtonStateChange,
    required this.scrollController,
    super.key,
    this.imageUrl,
  });
  @override
  State<BioTab> createState() => _BioTabState();
}

class _BioTabState extends State<BioTab> {
  @override
  void initState() {
    super.initState();
    // Add listeners to the text controllers
    widget.bioController.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.bioController.removeListener(_validateInput);
    super.dispose();
  }

  // Validate form inputs and enable/disable button
  void _validateInput() {
    widget.onButtonStateChange(widget.bioController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return StyledRegistrationPadding(
      child: StyledKeyboardDismiss(
        child: StyledSingleChildScrollView(
          scrollController: widget.scrollController,
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
                        context.localizations.describe_yourself,
                        context.localizations.motivated_to_join,
                        context.localizations.help_in_communities,
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
