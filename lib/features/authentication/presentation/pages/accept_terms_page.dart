import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/reasons/github_error_reason.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/authentication/domain/usecases/fetch_terms_use_case.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';
import 'package:online_tribes/router/app_routes.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class AcceptTermsPage extends StatefulWidget {
  const AcceptTermsPage({super.key});

  @override
  State<AcceptTermsPage> createState() => _AcceptTermsPageState();
}

class _AcceptTermsPageState extends State<AcceptTermsPage> {
  late Future<dartz.Either<BaseApiError<GithubErrorReason>, String>>
      markdownData;
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final termsService = GetIt.instance<FetchTermsUseCase>();

    // Fetch the terms here after dependencies (including context) are available
    markdownData = termsService.execute(
      languageCode: context.localizations.localeName,
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isAtBottom = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // Function to handle link tap
  Future<void> _onTapLink(String text, String? href, String title) async {
    if (href != null && await canLaunchUrl(Uri.parse(href))) {
      await launchUrl(
        Uri.parse(href),
        mode: LaunchMode.inAppWebView,
      ); // Open the link in the default browser
    } else {
      if (!context.mounted) {
        return;
      }
      getIt<BannerService>().showErrorBanner(
        // ignore: use_build_context_synchronously
        message: '${context.localizations.termsLinkError} $href',
        // ignore: use_build_context_synchronously
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StyledAppBar(
        title: '',
      ),
      body: SafeArea(
        child: StyledMainPadding(
          child: Column(
            children: [
              Text(
                context.localizations.termsAcceptTermsTitle,
                style: context.appTextStyles.headline4,
              ),
              Text(
                context.localizations.termsAcceptTermsSubtitle,
                style: context.appTextStyles.bodyText1,
              ),
              Expanded(
                child: FutureBuilder<
                    dartz.Either<BaseApiError<GithubErrorReason>, String>>(
                  future: markdownData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: StyledLoadingIndicatorWidget(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          context.localizations.termsLoadError,
                          style: context.appTextStyles.bodyText1,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return snapshot.data!.fold(
                        (error) => Center(
                          child: Text(
                            context.localizations.termsLoadError,
                            style: context.appTextStyles.bodyText1,
                          ),
                        ),
                        (terms) => Markdown(
                          controller: _scrollController,
                          data: terms,
                          styleSheet: MarkdownStyleSheet(
                            p: context.appTextStyles.bodyText2,
                          ),
                          onTapLink: _onTapLink, // Add link tap handler
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          context.localizations.termsLoadError,
                          style: context.appTextStyles.bodyText1,
                        ),
                      );
                    }
                  },
                ),
              ),
              20.verticalSpace,
              if (_isAtBottom)
                StyledFilledButton(
                  buttonText: context.localizations.termsContinueText,
                  onPressed: () {
                    UserRegistrationRoute().go(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
