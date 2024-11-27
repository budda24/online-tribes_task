import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledTagsChips extends StatefulWidget {
  final List<String> values;
  final void Function(String)? onDelete;

  // Named constructor for chips with delete functionality
  const StyledTagsChips.withDelete({
    required this.values,
    required this.onDelete,
    super.key,
  });

  // Named constructor for chips without delete functionality
  const StyledTagsChips.withoutDelete({
    required this.values,
    super.key,
  }) : onDelete = null;

  @override
  State<StyledTagsChips> createState() => _StyledTagsChipsState();
}

class _StyledTagsChipsState extends State<StyledTagsChips> {
  late ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    _updateScrollIndicators();
  }

  void _updateScrollIndicators() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    setState(() {
      _canScrollLeft = currentScroll > 0;
      _canScrollRight = currentScroll < maxScroll;
    });
  }

  @override
  void didUpdateWidget(covariant StyledTagsChips oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollIndicators();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: widget.values.reversed.map((language) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Chip(
                    shadowColor: context.appColors.shadowColor,
                    elevation: 3,
                    backgroundColor: context.appColors.secondaryColor,
                    label: Text(
                      language,
                      style: context.appTextStyles.bodyText1,
                    ),
                    onDeleted: widget.onDelete != null
                        ? () => widget.onDelete!(language)
                        : null,
                    deleteIconColor: widget.onDelete != null
                        ? Theme.of(context).primaryColor
                        : null,
                    side: const BorderSide(color: Colors.transparent),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (_canScrollLeft)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_circle_left_rounded),
                onPressed: _scrollToLeft,
              ),
            ),
          ),
        if (_canScrollRight)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.arrow_circle_right_rounded),
                onPressed: _scrollToRight,
              ),
            ),
          ),
      ],
    );
  }

  void _scrollToLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
// TODO(franio): Old chips sctructure with weraping
/* class StyledTagsChips extends StatelessWidget {
  final List<String> values;
  final void Function(String) onDelete;

  const StyledTagsChips({
    required this.values,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: values.map((language) {
        return Chip(
          backgroundColor: Theme.of(context).disabledColor,
          deleteIconColor: Theme.of(context).primaryColor,
          side: const BorderSide(color: Colors.transparent),
          label: Text(
            language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onDeleted: () => onDelete(language),
        );
      }).toList(),
    );
  }
}
 */
