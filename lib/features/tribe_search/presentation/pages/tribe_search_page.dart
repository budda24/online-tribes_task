import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/main_drawer/presentation/widgets/styled_drawer.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';
import 'package:online_tribes/features/tribe_search/presentation/cubit/tribe_search_cubit.dart';
import 'package:online_tribes/features/tribe_search/presentation/cubit/tribe_search_state.dart';
import 'package:online_tribes/features/tribe_search/presentation/widgets/popular_tribes_section.dart';
import 'package:online_tribes/features/tribe_search/presentation/widgets/search_section.dart';
import 'package:online_tribes/features/tribe_search/presentation/widgets/shimmer_tribe_suggestions_section.dart';
import 'package:online_tribes/features/tribe_search/presentation/widgets/tribe_suggestions_section.dart';

class TribeSearchPage extends StatefulWidget {
  const TribeSearchPage({super.key});

  @override
  State<TribeSearchPage> createState() => _TribeSearchPageState();
}

class _TribeSearchPageState extends State<TribeSearchPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<TribeSearchCubit>().loadSearchData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StyledDrawer(),
      appBar: StyledAppBar.withDrawer(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: context.appColors.textColor,
          ),
        ),
        title: context.localizations.onlineTribes,
      ),
      body: BlocListener<TribeSearchCubit, TribeSearchState>(
        listener: (context, state) {
          state.maybeWhen(
            failure: (error) => getIt<BannerService>().showErrorBanner(
              context: context,
              message: ErrorUtility.getErrorMessage(context, error),
            ),
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              30.verticalSpace,
              const Header(),
              50.verticalSpace,
              const SearchSection(),
              40.verticalSpace,
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return BlocBuilder<TribeSearchCubit, TribeSearchState>(
      builder: (context, state) => state.maybeWhen(
        loading: () => const ShimmerTribeSuggestionsSection(),
        ready: () => const PopularTribesSection(),
        searchSuggestionsPopulated: (_) => const PopularTribesSection(),
        searchSuggestionsCleared: () => const PopularTribesSection(),
        tribeSuggestionsLoading: (_) => const ShimmerTribeSuggestionsSection(),
        tribeSuggestionsPopulated: (searchPhraseSelected, _, tribeSuggestions) {
          return TribeSuggestionsSection(
            searchPhraseSelected: searchPhraseSelected,
            tribeSuggestions: tribeSuggestions,
          );
        },
        failure: (_) => const ShimmerTribeSuggestionsSection(),
        orElse: () => const SizedBox(),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.localizations.discoverTribes,
          style: context.appTextStyles.headline2,
        ),
        RichText(
          text: TextSpan(
            style: context.appTextStyles.subtitle2BOld,
            children: [
              TextSpan(
                style: context.appTextStyles.subtitle2BOld,
                text: context.localizations.or,
              ),
              TextSpan(
                style: context.appTextStyles.subtitle2BOld.copyWith(
                  color: context.appColors.primaryColor,
                ),
                text: ' ${context.localizations.createYourOwn}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
