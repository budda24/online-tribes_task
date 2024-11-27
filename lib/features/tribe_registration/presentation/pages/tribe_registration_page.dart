import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_service.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/tribe_registration_error_utility.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar_view.dart';
import 'package:online_tribes/features/tribe_registration/domain/entities/tribe_registration_step.dart';
import 'package:online_tribes/features/tribe_registration/presentation/bloc/bloc/tribe_registration_cubit.dart';
import 'package:online_tribes/features/tribe_registration/presentation/bloc/bloc/tribe_registration_state.dart';
import 'package:online_tribes/features/tribe_registration/presentation/widgets/tribe_bio_tab.dart';
import 'package:online_tribes/features/tribe_registration/presentation/widgets/tribe_criteria_tab.dart';
import 'package:online_tribes/features/tribe_registration/presentation/widgets/tribe_name_tab.dart';
import 'package:online_tribes/features/tribe_registration/presentation/widgets/tribe_theme_tab.dart';
import 'package:online_tribes/router/app_routes.dart';

class TribeRegistrationPage extends StatefulWidget {
  const TribeRegistrationPage({super.key});
  @override
  State<TribeRegistrationPage> createState() => TribeRegistrationPageState();
}

class TribeRegistrationPageState extends State<TribeRegistrationPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  File? _image;
  String? _tribalSignUrl;
  List<String> _tribeThemes = [];
  Timer? _timer;
  final _tabs = [
    const Tab(text: 'Name'),
    const Tab(text: 'Criteria'),
    const Tab(text: 'Bio'),
    const Tab(text: 'Theme'),
  ];
  TabController? _tabController;

  final logger = getIt<LoggerService>();

  final ScrollController _scrollController = ScrollController();
  double _previousBottomInset = 0;

  // Global keys for each form
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _criteriaFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bioFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _themeFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _membershipCriteriaController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _themeController = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<TribeRegistrationCubit>().loadTribeRegistrationData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    _languageController.dispose();
    _typeController.dispose();
    _themeController.dispose();
    _membershipCriteriaController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void setImagePicked(File? image) {
    setState(() {
      _image = image;
    });
  }

  void _onNameTabButtonStateChange(bool isEnabled) {
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }

  /// This method is called whenever the window metrics change,
  /// such as when the keyboard appears or disappears.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;

    if (bottomInset > 0 && _previousBottomInset == 0) {
      // Keyboard has appeared
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _scrollToBottom();
      });
    }

    _previousBottomInset = bottomInset;
  }

  /// Scrolls the view to the bottom to ensure the focused field is visible.
  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200.h,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleContinue() async {
    // Ensure _tabController is not null
    if (_tabController == null) return;

    // Map the current index to the enum value
    final currentStep = TribeRegistrationStep.values[_tabController!.index];

    final tribeRegistrationCubit = context.read<TribeRegistrationCubit>();

    // Switch on the enum value
    switch (currentStep) {
      case TribeRegistrationStep.name:
        if (_nameFormKey.currentState?.validate() ?? false) {
          await tribeRegistrationCubit.saveNameTab(
            _nameController.text,
            _languageController.text,
          );
        }
        break;

      case TribeRegistrationStep.criteria:
        if (_criteriaFormKey.currentState?.validate() ?? false) {
          if (_image == null) {
            getIt<BannerService>().showErrorBanner(
              message: context.localizations.tribeSignNotPicked,
              context: context,
            );
            return;
          }
          await tribeRegistrationCubit.saveCriteriaTab(
            _membershipCriteriaController.text,
            _typeController.text,
            _image!,
          );
        }
        break;

      case TribeRegistrationStep.bio:
        if (_bioFormKey.currentState?.validate() ?? false) {
          await tribeRegistrationCubit.saveBioTab(
            _bioController.text,
          );
        }
        break;

      case TribeRegistrationStep.theme:
        if (_tribeThemes.isNotEmpty) {
          await tribeRegistrationCubit.saveThemeTab(
            _tribeThemes,
          );
          _timer?.cancel();

          // After saving themes, navigate to post-registration route
          if (!mounted) return;
          final userId = getIt<IAuthService>().user?.uid;
          if (userId == null) {
            // Handle user not logged in
            return;
          }

          final getTribeResult = await tribeRegistrationCubit
              .getLastRegisteredTribeUseCase(userId);

          getTribeResult.fold(
            tribeRegistrationCubit.showError,
            (tribe) {
              TribePostRegistrationRoute(tribeName: tribe.name).go(context);
            },
          );
        }
        break;

      case TribeRegistrationStep.postRegistration:
        break;
      case TribeRegistrationStep.finished:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StyledAppBar.withBackButton(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocListener<TribeRegistrationCubit, TribeRegistrationState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              loading: (_) {
                setState(() {
                  _isLoading = true;
                });
              },
              failure: (value) {
                setState(() {
                  _isLoading = false;
                });
                // Handle failure and show error banner
                getIt<BannerService>().showErrorBanner(
                  message: TribeRegistrationErrorUtility.getErrorMessage(
                    context,
                    value.error,
                  ),
                  context: context,
                );
              },
              tribeDataLoaded: (state) {
                // Populate UI with the loaded tribe data
                setState(() {
                  _isLoading = false;
                });
                final tribe = state.tribe;

                _nameController.text = tribe.name;
                _languageController.text = tribe.language ?? '';
                _typeController.text = tribe.type ?? '';
                _membershipCriteriaController.text =
                    tribe.membershipCriteria ?? '';
                _bioController.text = tribe.bio ?? '';
                _tribeThemes = tribe.themes ?? [];
                _tribalSignUrl = tribe.signUrl ?? '';

                _tabController = TabController(
                  length: 4,
                  vsync: this,
                  initialIndex: tribe.lastTribeRegistrationStepIndex ?? 0,
                );
              },
              submittingSuccess: (state) {
                setState(() {
                  _isLoading = false;
                });
                _nameController.text = state.tribe.name;
                _languageController.text = state.tribe.language ?? '';
                _typeController.text = state.tribe.type ?? '';
                _membershipCriteriaController.text =
                    state.tribe.membershipCriteria ?? '';
                _bioController.text = state.tribe.bio ?? '';
                _tribeThemes = state.tribe.themes ?? [];
                _tribalSignUrl = state.tribe.signUrl ?? '';

                if ((state.tribe.lastTribeRegistrationStepIndex ?? 0) + 1 <
                    _tabs.length) {
                  _tabController?.animateTo(
                    state.tribe.lastTribeRegistrationStepIndex ?? 0,
                  );
                } else {
                  _tabController?.animateTo(_tabs.length - 1);
                }
              },
            );
          },
          child: _isLoading
              ? const Center(
                  child: StyledLoadingIndicatorWidget(),
                )
              : StyledMainPadding(
                  child: Column(
                    children: [
                      StyledTabBar(
                        tabs: _tabs,
                        tabController: _tabController,
                      ),
                      Expanded(
                        child: StyledTabBarView(
                          tabController: _tabController,
                          tabViews: [
                            TribeNameTab(
                              formKey: _nameFormKey,
                              onButtonStateChange: _onNameTabButtonStateChange,
                              tribeNameController: _nameController,
                              languageController: _languageController,
                              scrollController: _scrollController,
                            ),
                            TribeCriteriaTab(
                              formKey: _criteriaFormKey,
                              onImagePicked: setImagePicked,
                              onButtonStateChange: _onNameTabButtonStateChange,
                              tribeCriteriaController:
                                  _membershipCriteriaController,
                              typeController: _typeController,
                              scrollController: _scrollController,
                              initImageUrl: _tribalSignUrl,
                              initImageFile: _image,
                            ),
                            TribeBioTab(
                              formKey: _bioFormKey,
                              onButtonStateChange: _onNameTabButtonStateChange,
                              bioController: _bioController,
                              imageUrl: _tribalSignUrl,
                            ),
                            TribeThemeTab(
                              themes: _tribeThemes,
                              formKey: _themeFormKey,
                              onButtonStateChange: _onNameTabButtonStateChange,
                              themeController: _themeController,
                              imageUrl: _tribalSignUrl,
                              assignThemes: (theme) {
                                setState(() {
                                  _tribeThemes = theme;
                                });
                              },
                              removeTheme: (theme) {
                                setState(() {
                                  _tribeThemes
                                      .removeWhere((value) => value == theme);
                                });
                              },
                              name: _nameController.text,
                              scrollController: _scrollController,
                            ),
                          ],
                        ),
                      ),
                      if (_isButtonEnabled)
                        StyledFilledButton(
                          onPressed: _handleContinue,
                          buttonText: context.localizations.continueText,
                        )
                      else
                        StyledFilledButton.disabled(
                          buttonText: context.localizations.continueText,
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
