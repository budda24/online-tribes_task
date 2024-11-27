// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_tag_chips.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_rectangle_profile_picture.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_profile_name.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';
import 'package:online_tribes/features/shared/widgets/styled_type_ahead_field.dart';

class AgeTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final double? age;
  final List<String> languages;
  final String name;
  final String? imageUrl;
  final TextEditingController languageTextEditingController;
  final ScrollController scrollController;
  final void Function(double) setAge;
  final void Function(String) addLanguage;

  const AgeTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.age,
    required this.languages,
    required this.name,
    required this.imageUrl,
    required this.languageTextEditingController,
    required this.scrollController,
    required this.setAge,
    required this.addLanguage,
    super.key,
  });

  @override
  State<AgeTab> createState() => _AgeTabState();
}

class _AgeTabState extends State<AgeTab> {
  late double? _currentAge;
  List<String> _languages = [];
  @override
  void initState() {
    _languages = widget.languages;
    _currentAge = widget.age;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateInput();
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.languageTextEditingController.removeListener(_validateInput);
    super.dispose();
  }

  void _removeLanguage(String language) {
    setState(() {
      _languages.remove(language);
    });

    _validateInput();
  }

  // Validate form inputs and enable/disable button
  void _validateInput() {
    final isValid = _languages.isNotEmpty && _currentAge != null;

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
              RoundedRectangleProfilePicture(
                imageUrl: widget.imageUrl,
              ),
              StyledProfileName(
                name: widget.name,
              ),
              20.verticalSpace,
              StyledTypeAheadField(
                onItemSelected: (language) {
                  setState(() {
                    if (!_languages.contains(language)) {
                      widget.addLanguage(language);
                    }
                    _validateInput();
                  });
                  widget.languageTextEditingController.clear();
                },
                hintText: context.localizations.languageHintText,
                controller: widget.languageTextEditingController,
                document: FirestoreCollections.typeAheadLanguagesDoc,
                canAdd: false,
                showListOfAll: true,
                maxSuggestionHeight: 0.15.sh,
              ),
              20.verticalSpace,
              if (_languages.isNotEmpty)
                StyledTagsChips.withDelete(
                  values: _languages,
                  onDelete: _removeLanguage,
                ),
              SizedBox(
                height: 0.3.sh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _currentAge ?? 16,
                            min: 16,
                            max: 100,
                            onChanged: (value) {
                              setState(() {
                                widget.setAge(value);
                                _currentAge = value;
                                _validateInput();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${context.localizations.ageLabel}: ${(_currentAge ?? 16).round()}',
                        style: context.appTextStyles.subtitle1,
                      ),
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
