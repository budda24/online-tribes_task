import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/type_ahead_service.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_text_form_field.dart';

class StyledTypeAheadField extends StatefulWidget {
  // Widget for type-ahead field with suggestions and option to add new entries.

  final String hintText;
  final TextEditingController controller;
  final String document;
  final FormFieldValidator<String>? validator;
  final bool canAdd;
  final Duration debounceDuration;
  final double maxSuggestionHeight;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isValid)? onSuggestionValid;
  final bool isCapitalize;
  final void Function(String)? onItemSelected;
  final FocusNode? focusNode;
  final bool showListOfAll; // New flag to show all suggestions when true

  const StyledTypeAheadField({
    required this.hintText,
    required this.controller,
    required this.document,
    this.validator,
    this.canAdd = true,
    this.debounceDuration = const Duration(milliseconds: 800),
    this.maxSuggestionHeight = 130.0,
    this.isCapitalize = true,
    super.key,
    this.onSuggestionValid,
    this.onItemSelected,
    this.focusNode,
    this.showListOfAll = false, // Initialize the flag
  });

  @override
  State<StyledTypeAheadField> createState() => _StyledTypeAheadFieldState();
}

class _StyledTypeAheadFieldState extends State<StyledTypeAheadField> {
  final _typeAheadService =
      getIt<TypeAheadService>(); // Service to fetch suggestions
  final _loggerService = getIt<LoggerService>();
  Timer? _debounce; // Timer to manage debounce behavior
  List<String> _suggestions = []; // List of fetched suggestions
  bool _isSuggestionVisible = false; // Flag to toggle suggestion visibility
  bool isAddAllowed = false; // Controls when "add new entry" can appear
  final addWidgetDaleyTime = const Duration(milliseconds: 400);

  late FocusNode _focusNode; // Focus node to detect focus changes
  bool _disposeFocusNode =
      false; // Flag to dispose focus node if created internally

  bool _isLoading = false; // Loading state for fetching suggestions

  late ScrollController _scrollController;
  bool _showScrollIndicator = false; // Visibility flag for scroll indicator

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged); // Listen to input changes

    // Initialize the focus node
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.focusNode == null) {
      _disposeFocusNode = true; // We'll dispose it since we created it
    }

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollIndicator();
    });

    _focusNode.addListener(_onFocusChange); // Listen to focus changes
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce on dispose
    widget.controller.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChange);
    if (_disposeFocusNode) {
      _focusNode.dispose(); // Dispose focus node if we created it
    }
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (!_focusNode.hasFocus) return; // Exit if not focused
    isAddAllowed = false; // Keep the add item appear after query search
    _suggestions = []; // Clear all suggestions after user starts to type
    _isSuggestionVisible = true; // Show suggestions when typing
    _debounceSearch(widget.controller.text); // Debounce search queries
  }

  void _onScroll() {
    _updateScrollIndicator();
  }

  void _updateScrollIndicator() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (mounted) {
      setState(() {
        _showScrollIndicator = maxScroll > 0 && currentScroll < maxScroll;
      });
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isLoading = true;
        _isSuggestionVisible = true;
      });
      _debounceSearch(widget.controller.text);
    } else {
      setState(() {
        _isSuggestionVisible = false;
        _suggestions = [];
      });
    }
  }

  void _debounceSearch(String query) {
    setState(() {
      _isLoading = true;
    });
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel(); // Cancel previous debounce
    }

    // Start debounce timer
    _debounce = Timer(widget.debounceDuration, () async {
      if (query.isNotEmpty || (query.isEmpty && widget.showListOfAll)) {
        try {
          final results = query.isNotEmpty
              ? await _typeAheadService.fetchSuggestions(
                  document: widget.document,
                  query: query,
                )
              : await _typeAheadService.fetchAllSuggestions(
                  document: widget.document,
                );

          if (mounted) {
            setState(() {
              _suggestions = results; // Update suggestion list
              isAddAllowed = false; // Disable add option temporarily
              _isLoading = false; // Stop loading
            });
            _updateScrollIndicator();

            // Check if input matches any suggestions
            final isValid = _suggestions.contains(query);
            widget.onSuggestionValid
                ?.call(isValid); // Notify if suggestion is valid

            // Enable "add new entry" after delay
            await Future.delayed(addWidgetDaleyTime, () {
              if (mounted) {
                setState(() {
                  isAddAllowed = true;
                });
              }
            });
          }
        } catch (e, stackTrace) {
          _loggerService.logError(
            message: 'Error fetching suggestions',
            error: e,
            stackTrace: stackTrace,
          );

          // Handle error: clear suggestions, notify invalid input
          if (mounted) {
            setState(() {
              isAddAllowed = false;
              _suggestions.clear();
              _isLoading = false; // Stop loading on error
            });
            widget.onSuggestionValid?.call(false);
          }
        }
      } else {
        // Clear suggestions on empty input if showListOfAll is false
        if (mounted) {
          setState(() {
            _suggestions.clear();
            isAddAllowed = false;
            _isLoading = false; // No loading needed
          });
          widget.onSuggestionValid?.call(false);
        }
      }
    });
  }

  // Handle selection of suggestion from the list
  void _onSuggestionSelected(String suggestion) {
    widget.controller.text = suggestion;
    setState(() {
      _isSuggestionVisible = false; // Hide suggestions
      _suggestions.clear(); // Clear suggestion list
    });
    _focusNode.unfocus(); // Unfocus the TextField
    widget.onItemSelected?.call(suggestion); // Notify item selected
  }

  // Add new entry when not found in suggestions
  Future<void> _addNewEntry(String entry) async {
    final capitalizedEntry = widget.isCapitalize ? entry.capitalize() : entry;

    try {
      await _typeAheadService.addNewEntry(widget.document, capitalizedEntry);
      setState(() {
        widget.controller.text = capitalizedEntry; // Update text field
        _suggestions.add(capitalizedEntry); // Add to suggestions
        _isSuggestionVisible = false;
        _suggestions.clear();
      });
      _focusNode.unfocus(); // Unfocus the text field
      widget.onItemSelected?.call(capitalizedEntry); // Notify new item added
    } catch (e, stackTrace) {
      _loggerService.logError(
        message: 'Error adding new entry',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StyledTextFormField(
          maxLength: 15,
          hintText: widget.hintText,
          controller: widget.controller,
          focusNode: _focusNode, // Use the managed focus node
          validator: widget.validator,
        ),
        // Display progress indicator when loading
        if (_isLoading) ...[
          10.verticalSpace,
          SizedBox(
            height: 50.h,
            child: const StyledLoadingIndicatorWidget(),
          ),
        ],
        // Display suggestion list if there are suggestions and they are visible
        if (_suggestions.isNotEmpty && _isSuggestionVisible)
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: widget.maxSuggestionHeight.h,
                ),
                padding: EdgeInsets.only(bottom: 20.h),
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () => _onSuggestionSelected(_suggestions[index]),
                    );
                  },
                ),
              ),
              if (_showScrollIndicator)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: context.appColors.primaryColor,
                      size: 30.h,
                    ),
                  ),
                ),
            ],
          ),
        // Show "Add" option if allowed and input doesn't match existing suggestions
        if (widget.canAdd && isAddAllowed)
          if (!_suggestions.contains(widget.controller.text.trim()) &&
              widget.controller.text.isNotEmpty &&
              _isSuggestionVisible)
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: context.appColors.primaryColor,
                    size: 18,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Add "${widget.controller.text}"',
                      style: context.appTextStyles.subtitle1,
                    ),
                  ),
                ],
              ),
              onTap: () => _addNewEntry(
                widget.controller.text,
              ), // Add new entry when tapped
            )
          else
            const SizedBox.shrink(),
      ],
    );
  }
}
