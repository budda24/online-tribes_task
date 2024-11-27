import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/core/services/date_conversion_service.dart';
import 'package:online_tribes/core/utils/validation_utillity.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/utils/item_manager_mixin.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_tag_chips.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';
import 'package:online_tribes/features/shared/widgets/profiles/styled_info_container.dart';
import 'package:online_tribes/features/shared/widgets/profiles/styled_profile_info.dart';
import 'package:online_tribes/features/shared/widgets/styled_type_ahead_field.dart';
import 'package:online_tribes/features/shared/widgets/user_profile/styled_divider.dart';

class UserProfileAboutTab extends StatefulWidget {
  final bool isEditing;
  final UserModel user;
  final void Function(UserModel) onUserUpdated;
  final File? profilePicture;
  final void Function(File) onProfilePictureChanged;

  const UserProfileAboutTab({
    required this.isEditing,
    required this.user,
    required this.onUserUpdated,
    required this.onProfilePictureChanged,
    super.key,
    this.profilePicture,
  });

  @override
  State<UserProfileAboutTab> createState() => _UserProfileAboutTabState();
}

class _UserProfileAboutTabState extends State<UserProfileAboutTab>
    with ItemManagerMixin<UserProfileAboutTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _bioController;
  late TextEditingController _hobbiesController;
  late TextEditingController _genderController;
  late TextEditingController _placeController;
  List<String> _hobbies = [];
  bool _informationChanged = false;

  @override
  void initState() {
    super.initState();
    _bioController =
        TextEditingController(text: widget.user.information?.bio ?? '');
    _hobbiesController = TextEditingController();
    _genderController =
        TextEditingController(text: widget.user.information?.gender ?? '');
    _placeController =
        TextEditingController(text: widget.user.information?.myPlace ?? '');

    _hobbies = List<String>.from(widget.user.information?.hobbies ?? []);

    initItemManager(
      initialItems: widget.user.information?.hobbies ?? [],
      controller: _hobbiesController,
    );
  }

  @override
  void validateInput() {
    setState(() {
      _informationChanged = true;
    });
  }

  @override
  void onItemsChanged(List<String> items) {
    setState(() {
      _hobbies = items;
    });
  }

  @override
  void onLimitExceeded(String item) {
    getIt<BannerService>().showInfoBanner(
      context: context,
      message: context.localizations.hobbyLimitExceedInfo,
    );
  }

  @override
  void dispose() {
    disposeItemManager();
    _bioController.dispose();
    _hobbiesController.dispose();
    _genderController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedUser = widget.user
        ..updateInformation((information) {
          return information.copyWith(
            bio: _bioController.text,
            hobbies: _hobbies,
            gender: _genderController.text,
            myPlace: _placeController.text,
          );
        });

      widget.onUserUpdated(updatedUser);
      setState(() {
        _informationChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.verticalSpace,
            if (widget.isEditing)
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
                  controller: _bioController,
                  onChanged: (_) => validateInput(),
                ),
              )
            else
              StyledInformationContainer(
                text: widget.user.information?.bio ?? '',
              ),
            18.verticalSpace,
            const StyledDivider(),
            18.verticalSpace,
            if (widget.isEditing) ...[
              StyledTypeAheadField(
                onItemSelected: addItem,
                hintText: context.localizations.hobbiesHintText,
                controller: _hobbiesController,
                document: FirestoreCollections.typeAheadHobbiesDoc,
                onSuggestionValid: (isValid) =>
                    isValid ? validateInput() : null,
                showListOfAll: true,
                maxSuggestionHeight: 0.15.sh,
              ),
              SizedBox(height: 20.h),
              if (_hobbies.isNotEmpty)
                StyledTagsChips.withDelete(
                  values: _hobbies,
                  onDelete: removeItem,
                ),
            ] else
              StyledTagsChips.withoutDelete(
                values: widget.user.information?.hobbies ?? [],
              ),
            SizedBox(height: 20.h),
            const StyledDivider(),
            if (widget.isEditing) ...[
              StyledTypeAheadField(
                showListOfAll: true,
                document: FirestoreCollections.typeAheadGenderDoc,
                hintText: context.localizations.genderHint,
                validator: (value) => null,
                controller: _genderController,
                onSuggestionValid: (isValid) =>
                    isValid ? validateInput() : null,
              ),
              SizedBox(height: 10.h),
              StyledTypeAheadField(
                showListOfAll: true,
                document: FirestoreCollections.typeAheadPlacesDoc,
                hintText: context.localizations.myPlaceHint,
                validator: (value) => null,
                controller: _placeController,
                onSuggestionValid: (isValid) =>
                    isValid ? validateInput() : null,
              ),
            ] else
              UserProfileInfoDisplay(user: widget.user),
            if (widget.isEditing) ...[
              SizedBox(height: 32.h),
              StyledFilledButton(
                onPressed: _informationChanged ? _saveChanges : null,
                buttonText: context.localizations.userProfileConfirmChange,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UserProfileInfoDisplay extends StatelessWidget {
  final UserModel user;

  const UserProfileInfoDisplay({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dateConversionService = getIt<DateConversionService>();

    return StyledProfileInfoDisplay(
      leftColumnItems: [
        ProfileInfoItem(
          icon: Icons.access_time,
          text:
              '${context.localizations.userProfileActive} ${dateConversionService.getLastActiveString(user.userActivity?.lastTimeActive ?? DateTime.now())} ${context.localizations.userProfileAgo}',
        ),
        ProfileInfoItem(
          icon: Icons.cake,
          text: user.information?.age == null
              ? ''
              : user.information!.age!.toString(),
        ),
      ],
      rightColumnItems: [
        ProfileInfoItem(
          icon: Icons.location_on,
          text: user.information?.myPlace ?? '',
        ),
        ProfileInfoItem(
          icon: Icons.person,
          text: user.information?.gender ?? '',
        ),
        ProfileInfoItem(
          icon: Icons.calendar_month_outlined,
          text: dateConversionService.formatDate(
            user.userActivity?.profileCreatedAt ?? DateTime.now(),
            format: 'MMMM dd, yyyy',
          ),
        ),
      ],
    );
  }
}
