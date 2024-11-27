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
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';
import 'package:online_tribes/features/shared/widgets/styled_type_ahead_field.dart';

class NameTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final TextEditingController userNameController;
  final TextEditingController genderController;
  final TextEditingController myPlaceController;
  final void Function(File?) onImagePicked;
  final ScrollController scrollController;
  final String? imageUrl;
  final File? initialImageFile;
  final bool isValidGender;
  final bool isValidPlace;
  final ValueChanged<bool> onGenderValidChange;
  final ValueChanged<bool> onPlaceValidChange;

  const NameTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.userNameController,
    required this.genderController,
    required this.myPlaceController,
    required this.onImagePicked,
    required this.scrollController,
    required this.onGenderValidChange,
    required this.onPlaceValidChange,
    required this.isValidGender,
    required this.isValidPlace,
    this.imageUrl,
    this.initialImageFile,
    super.key,
  });

  @override
  State<NameTab> createState() => _NameTabState();
}

class _NameTabState extends State<NameTab> {
  @override
  Widget build(BuildContext context) {
    return StyledRegistrationPadding(
      child: StyledKeyboardDismiss(
        child: StyledSingleChildScrollView(
          scrollController: widget.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StyledProfilePicturePicker(
                onImagePicked: (imageFile) {
                  widget.onImagePicked(imageFile);
                },
                initialImageUrl: widget.imageUrl,
                initialImageFile: widget.initialImageFile,
              ),
              43.verticalSpace,
              Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    StyledTextFormField(
                      maxLength: 10,
                      hintText: context.localizations.userNameHint,
                      validator: (value) => ValidationUtility.validateUsername(
                        context,
                        value,
                      ),
                      controller: widget.userNameController,
                    ),
                    24.verticalSpace,
                    StyledTypeAheadField(
                      showListOfAll: true,
                      document: FirestoreCollections.typeAheadGenderDoc,
                      hintText: context.localizations.genderHint,
                      validator: (value) => null,
                      controller: widget.genderController,
                      onSuggestionValid: (isValid) {
                        widget.onGenderValidChange(isValid);
                        // _validateInput();
                      },
                    ),
                    24.verticalSpace,
                    StyledTypeAheadField(
                      showListOfAll: true,
                      document: FirestoreCollections.typeAheadPlacesDoc,
                      hintText: context.localizations.myPlaceHint,
                      validator: (value) => null,
                      controller: widget.myPlaceController,
                      onSuggestionValid: (isValid) {
                        widget.onPlaceValidChange(isValid);
                        // _validateInput();
                      },
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
