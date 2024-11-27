// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/validation_utillity.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_profile_picture_picker.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_registration_hints.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';
import 'package:online_tribes/features/shared/widgets/styled_type_ahead_field.dart';

class TribeCriteriaTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final TextEditingController typeController;
  final TextEditingController tribeCriteriaController;
  final void Function(File?) onImagePicked;
  final String? initImageUrl;
  final File? initImageFile;
  final ScrollController scrollController;

  const TribeCriteriaTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.typeController,
    required this.tribeCriteriaController,
    required this.onImagePicked,
    required this.scrollController,
    super.key,
    this.initImageUrl,
    this.initImageFile,
  });

  @override
  State<TribeCriteriaTab> createState() => _TribeCriteriaTabState();
}

class _TribeCriteriaTabState extends State<TribeCriteriaTab> {
  bool _isValidLanguage = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    widget.tribeCriteriaController.addListener(_validateInput);
    widget.typeController.addListener(_validateInput);
  }

  @override
  void dispose() {
    widget.tribeCriteriaController.removeListener(_validateInput);
    widget.typeController.removeListener(_validateInput);

    super.dispose();
  }

  // Validate form inputs and enable/disable button
  void _validateInput() {
    final isValid =
        widget.tribeCriteriaController.text.isNotEmpty && _isValidLanguage;

    widget.onButtonStateChange(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return StyledRegistrationPadding(
      child: StyledKeyboardDismiss(
        child: StyledSingleChildScrollView(
          scrollController: widget.scrollController,
          child: Column(
            children: [
              Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    StyledProfilePicturePicker(
                      onImagePicked: (imageFile) {
                        widget.onImagePicked(imageFile);
                        setState(() {
                          _imageFile = imageFile;
                        });
                      },
                      initialImageUrl: widget.initImageUrl,
                      initialImageFile: _imageFile,
                      // Pass the image URL
                    ),
                    43.verticalSpace,
                    StyledTypeAheadField(
                      showListOfAll: true,
                      document: FirestoreCollections.typeAheadTypesDoc,
                      hintText: context.localizations.tribeTypeHintText,
                      validator: (value) => null,
                      controller: widget.typeController,
                      onSuggestionValid: (isValid) {
                        setState(() {
                          _isValidLanguage = isValid;
                        });
                        _validateInput();
                      },
                    ),
                    24.verticalSpace,
                    SizedBox(
                      height: 150.h,
                      child: StyledTextFormField(
                        showCharacterCounter: true,
                        maxLength: 150,
                        maxLines: 20,
                        hintText: context.localizations.tribeCriteriaHintText,
                        validator: (value) =>
                            ValidationUtility.validateCriteria(
                          context,
                          value,
                        ),
                        controller: widget.tribeCriteriaController,
                      ),
                    ),
                    50.verticalSpace,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: StyledRegistrationHints(
                        hints: [
                          context.localizations.tribeRegistrationCriteriaHint1,
                          context.localizations.tribeRegistrationCriteriaHint2,
                        ],
                      ),
                    ),
                    12.verticalSpace,
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
