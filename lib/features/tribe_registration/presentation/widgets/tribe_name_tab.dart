// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/validation_utillity.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';
import 'package:online_tribes/features/shared/widgets/images/styled_logo_circular.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';
import 'package:online_tribes/features/shared/widgets/styled_type_ahead_field.dart';

class TribeNameTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final TextEditingController tribeNameController;
  final TextEditingController languageController;
  final ScrollController scrollController;

  const TribeNameTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.tribeNameController,
    required this.languageController,
    required this.scrollController,
    super.key,
  });

  @override
  State<TribeNameTab> createState() => _TribeNameTabState();
}

class _TribeNameTabState extends State<TribeNameTab> {
  bool _isValidLanguage = false;

  @override
  void initState() {
    super.initState();

    widget.tribeNameController.addListener(_validateInput);
    widget.languageController.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.tribeNameController.removeListener(_validateInput);
    widget.languageController.removeListener(_validateInput);

    super.dispose();
  }

  // Validate form inputs and enable/disable button
  void _validateInput() {
    final isValid =
        widget.tribeNameController.text.isNotEmpty && _isValidLanguage;

    widget.onButtonStateChange(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return StyledRegistrationPadding(
      child: StyledKeyboardDismiss(
        child: StyledSingleChildScrollView(
          scrollController: widget.scrollController,
          isKeyboardDismissOnDrag: true,
          child: Column(
            children: [
              StyledLogoCircular(
                size: 115.h,
              ),
              20.verticalSpace,
              Text(
                'Create your\ntribe',
                style: context.appTextStyles.headline1,
                textAlign: TextAlign.center,
              ),
              44.verticalSpace,
              Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    StyledTextFormField(
                      maxLength: 38,
                      hintText: context.localizations.tribeNameHint,
                      validator: (value) => ValidationUtility.validateTribeName(
                        context,
                        value,
                      ),
                      controller: widget.tribeNameController,
                    ),
                    24.verticalSpace,
                    StyledTypeAheadField(
                      document: FirestoreCollections.typeAheadLanguagesDoc,
                      hintText: context.localizations.languageHintText,
                      canAdd: false,
                      validator: (value) => null,
                      controller: widget.languageController,
                      onSuggestionValid: (isValid) {
                        setState(() {
                          _isValidLanguage = isValid;
                        });
                        _validateInput();
                      },
                      showListOfAll: true,
                      maxSuggestionHeight: 0.15.sh,
                    ),
                    24.verticalSpace,
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
