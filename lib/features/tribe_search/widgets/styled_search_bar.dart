import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/extensions/string_extensions.dart';
import 'package:online_tribes/theme/theme_context_extantion.dart';

class StyledSearchBar extends StatefulWidget {
  final ValueSetter<String> onValueChanged;
  final VoidCallback onClearButtonTap;

  const StyledSearchBar({
    required this.onValueChanged,
    required this.onClearButtonTap,
    super.key,
  });

  @override
  State<StyledSearchBar> createState() => _StyledSearchBarState();
}

class _StyledSearchBarState extends State<StyledSearchBar> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _isInputValid = true;
  static const _minSearchLength = 3;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() => setState(() {}));

    _textController.addListener(() {
      setState(() => _isInputValid = _validateInput(_textController.text));
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  bool _validateInput(String text) {
    if (text.isEmpty) return true;
    return text.removeWhitespace.length > 2;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          focusNode: _focusNode,
          autovalidateMode: AutovalidateMode.always,
          controller: _textController,
          decoration: _searchBarInputDecoration(
            context: context,
            isFocused: _focusNode.hasFocus,
            isInputValid: _isInputValid,
          ),
          onChanged: (value) {
            setState(() {
              // trigger set state to check textController.text length
              // and decide to build clear text button
            });
            widget.onValueChanged(value);
          },
          validator: (value) => _validateSearchText(value, context: context),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        ),
        _buildClearTextButton(),
      ],
    );
  }

  Widget _buildClearTextButton() {
    if (_textController.text.removeWhitespace.length < 3) {
      return const SizedBox();
    }

    return ClearTextButton(
      onTap: () {
        _textController.text = '';
        widget.onClearButtonTap();
        setState(() {});
      },
    );
  }

  String? _validateSearchText(String? value, {required BuildContext context}) {
    if (value == null || value.isEmpty) return null;
    if (value.removeWhitespace.length < _minSearchLength) {
      return context.localizations.searchLengthValidation(_minSearchLength);
    }
    return null;
  }
}

InputDecoration _searchBarInputDecoration({
  required BuildContext context,
  required bool isFocused,
  required bool isInputValid,
}) {
  return InputDecoration(
    prefixIcon: Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: const Icon(
        Icons.search,
        size: 25,
      ),
    ),
    prefixIconColor: isInputValid
        ? isFocused
            ? context.primaryColor
            : context.appColors.textColor
        : context.errorColor,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: context.appColors.textColor.withOpacity(0.6),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(24.r),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: context.appColors.primaryColor,
        width: 1.2.w,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(24.r),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: context.appColors.errorColor,
        width: 1.w,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(24.r),
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: context.appColors.errorColor,
        width: 1.w,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(24.r),
      ),
    ),
  );
}

class ClearTextButton extends StatelessWidget {
  final VoidCallback onTap;

  const ClearTextButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        backgroundColor: context.primaryColor,
        radius: 9.r,
        child: Icon(
          Icons.close,
          color: context.backgroundColor,
          size: 14.h,
        ),
      ),
      onPressed: onTap,
    );
  }
}
