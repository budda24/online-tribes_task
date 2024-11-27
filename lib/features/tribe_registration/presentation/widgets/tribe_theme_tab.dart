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

class TribeThemeTab extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onButtonStateChange;
  final String? imageUrl;
  final List<String> themes;
  final TextEditingController themeController;
  final void Function(List<String>) assignThemes;
  final void Function(String) removeTheme;
  final String name;
  final ScrollController scrollController;

  const TribeThemeTab({
    required this.formKey,
    required this.onButtonStateChange,
    required this.themes,
    required this.themeController,
    required this.assignThemes,
    required this.removeTheme,
    required this.name,
    required this.scrollController,
    super.key,
    this.imageUrl,
  });

  @override
  State<TribeThemeTab> createState() => _TribeThemeTabState();
}

class _TribeThemeTabState extends State<TribeThemeTab>
    with ItemManagerMixin<TribeThemeTab> {
  late List<String> _hobbies;

  @override
  void initState() {
    initItemManager(
      initialItems: widget.themes,
      controller: widget.themeController,
    );
    _hobbies = widget.themes;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateInput();
    });

    super.initState();
  }

  @override
  void dispose() {
    disposeItemManager();
    widget.themeController.removeListener(validateInput);
    super.dispose();
  }

  // Validate form inputs and enable/disable button
  @override
  void validateInput({bool? isSuggestionValid}) {
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
    widget.assignThemes(items);
  }

  @override
  void onLimitExceeded(String item) {
    getIt<BannerService>().showInfoBanner(
      context: context,
      message: context.localizations.hobbyLimitExceedInfo,
    );
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
              StyledProfileName(name: widget.name),
              20.verticalSpace,
              StyledTypeAheadField(
                maxSuggestionHeight: 200.h,
                showListOfAll: true,
                onItemSelected: addItem,
                hintText: context.localizations.tribeThemeHintText,
                controller: widget.themeController,
                document: FirestoreCollections.typeAheadHobbiesDoc,
                onSuggestionValid: (isSuggestionValid) => validateInput(),
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
