import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/extensions/string_extensions.dart';
import 'package:online_tribes/core/models/type_ahead_search_data_model.dart';
import 'package:online_tribes/features/tribe_search/presentation/cubit/tribe_search_cubit.dart';
import 'package:online_tribes/features/tribe_search/presentation/cubit/tribe_search_state.dart';
import 'package:online_tribes/features/tribe_search/widgets/styled_search_bar.dart';
import 'package:shimmer/shimmer.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              context.localizations.searchTribe,
              style: context.appTextStyles.subtitle2,
            ),
          ),
          BlocBuilder<TribeSearchCubit, TribeSearchState>(
            builder: (context, state) {
              if (state is TribeSearchLoading) {
                return const ShimmerSearchBar();
              } else {
                return const ActiveSearchBar();
              }
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            child: BlocBuilder<TribeSearchCubit, TribeSearchState>(
              builder: (context, state) => state.maybeWhen(
                searchSuggestionsPopulated: SuggestionsList.new,
                tribeSuggestionsLoading: SuggestionsList.new,
                tribeSuggestionsPopulated: (_, suggestions, __) =>
                    SuggestionsList(suggestions),
                orElse: () => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveSearchBar extends StatelessWidget {
  const ActiveSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledSearchBar(
      onClearButtonTap: context.read<TribeSearchCubit>().onSuggestionsCleared,
      onValueChanged: (value) {
        if (value.removeWhitespace.length < 3) {
          context.read<TribeSearchCubit>().onSuggestionsCleared();
        } else {
          context.read<TribeSearchCubit>().onSuggestionRequest(value);
        }
      },
    );
  }
}

class SuggestionsList extends StatelessWidget {
  final List<TypeAheadSearchDataModel> suggestions;

  const SuggestionsList(this.suggestions, {super.key});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const NothingFoundText();
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 8.h),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final item = suggestions[index];

          return InkWell(
            splashColor: context.appColors.primaryColorLight.withOpacity(0.2),
            onTap: () {
              FocusScope.of(context).unfocus();
              context.read<TribeSearchCubit>().onSuggestionTap(item);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 8.w,
              ),
              child: Text(
                item.key,
                style: context.appTextStyles.bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

class NothingFoundText extends StatelessWidget {
  const NothingFoundText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, top: 8.h),
      child: Text(
        context.localizations.nothingFound,
        style: context.appTextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class ShimmerSearchBar extends StatelessWidget {
  const ShimmerSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.appColors.shimmerBaseColor,
      highlightColor: context.appColors.shimmerHighlightColor,
      child: Container(
        height: 46.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
    );
  }
}
