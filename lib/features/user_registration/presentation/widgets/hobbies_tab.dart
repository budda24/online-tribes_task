// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/shared/utils/item_manager_mixin.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_tag_chips.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_rectangle_profile_picture.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_profile_name.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/shared/widgets/styled_regitration_padding.dart';
import 'package:online_tribes/features/shared/widgets/styled_type_ahead_field.dart';

class HobbiesTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final String? imageUrl;
  final List<String> hobbies;
  final TextEditingController hobbiesTextEditingController;
  final void Function(List<String>) assignHobbies;
  final void Function(String) removeHobby;
  final String name;

  const HobbiesTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.hobbies,
    required this.hobbiesTextEditingController,
    required this.assignHobbies,
    required this.removeHobby,
    required this.name,
    super.key,
    this.imageUrl,
  });

  @override
  State<HobbiesTab> createState() => _HobbiesTabState();
}

class _HobbiesTabState extends State<HobbiesTab>
    with ItemManagerMixin<HobbiesTab> {
  late List<String> _hobbies;

  @override
  void validateInput() {
    if (_hobbies.isNotEmpty) {
      widget.onButtonStateChange(true);
    } else {
      widget.onButtonStateChange(false);
    }
  }

  @override
  void onItemsChanged(List<String> items) {
    setState(() {
      _hobbies = items;
    });
    widget.assignHobbies(items);
  }

  @override
  void onLimitExceeded(String item) {
    getIt<BannerService>().showInfoBanner(
      context: context,
      message: context.localizations.hobbyLimitExceedInfo,
    );
  }

  @override
  void initState() {
    super.initState();
    _hobbies = widget.hobbies;
    initItemManager(
      initialItems: widget.hobbies,
      controller: widget.hobbiesTextEditingController,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateInput();
    });
  }

  @override
  void dispose() {
    disposeItemManager();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyledRegistrationPadding(
      child: StyledKeyboardDismiss(
        child: StyledSingleChildScrollView(
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
                onItemSelected: addItem,
                hintText: context.localizations.hobbiesHintText,
                controller: widget.hobbiesTextEditingController,
                document: FirestoreCollections.typeAheadHobbiesDoc,
                onSuggestionValid: (isSuggestionValid) => validateInput(),
                showListOfAll: true,
                maxSuggestionHeight: 0.15.sh,
              ),
              20.verticalSpace,
              if (_hobbies.isNotEmpty)
                StyledTagsChips.withDelete(
                  values: _hobbies,
                  onDelete: removeItem,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
