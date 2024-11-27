import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar_view.dart';
import 'package:online_tribes/features/user_registration/data/user_registration_error_utility.dart';
import 'package:online_tribes/features/user_registration/presentation/bloc/bloc/user_registration_cubit.dart';
import 'package:online_tribes/features/user_registration/presentation/bloc/bloc/user_registration_state.dart';
import 'package:online_tribes/features/user_registration/presentation/widgets/age_tab.dart';
import 'package:online_tribes/features/user_registration/presentation/widgets/bio_tab.dart';
import 'package:online_tribes/features/user_registration/presentation/widgets/hobbies_tab.dart';
import 'package:online_tribes/features/user_registration/presentation/widgets/name_tab.dart';
import 'package:online_tribes/router/app_routes.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});
  @override
  State<UserRegistrationPage> createState() => UserRegistrationPageState();
}

class UserRegistrationPageState extends State<UserRegistrationPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  File? _image;
  String? _imageUrl;
  Timer? _timer;
  final logger = getIt<LoggerService>();

  TabController? _tabController;
  final _tabs = [
    const Tab(text: 'Name'),
    const Tab(text: 'Age'),
    const Tab(text: 'Bio'),
    const Tab(text: 'Hobby'),
  ];

  final ScrollController _scrollController = ScrollController();
  double _previousBottomInset = 0;

  // Global keys for each form
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ageFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bioFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _hobbiesFormKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _myPlaceController = TextEditingController();
  final TextEditingController languageTextEditingController =
      TextEditingController();
  final TextEditingController _bioTextEditingController =
      TextEditingController();
  final TextEditingController _hobbiesTextEditingController =
      TextEditingController();

  double? _age;
  final List<String> _languages = [];
  List<String> _hobbies = [];
  bool _isButtonEnabled = false;
  bool _isLoading = true;
  bool _isValidGender = false;
  bool _isValidPlace = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _loadRegistrationData();
  }

  Future<void> _loadRegistrationData() async {
    await context.read<UserRegistrationCubit>().loadUserRegistrationData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    _genderController.dispose();
    _myPlaceController.dispose();
    _userNameController.dispose();
    _bioTextEditingController.dispose();
    _hobbiesTextEditingController.dispose();
    languageTextEditingController.dispose();
    _userNameController.removeListener(_validateInput);
    super.dispose();
  }

  // Validate form inputs and enable/disable button
  void _validateInput() {
    _userNameController.addListener(_validateInput);
    final isValid =
        _userNameController.text.isNotEmpty && _isValidGender && _isValidPlace;

    _onNameTabButtonStateChange(isValid);
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
    switch (_tabController?.index) {
      case 0:
        if (_image == null) {
          return getIt<BannerService>().showErrorBanner(
            message: context.localizations.userProfilePictureNotPicked,
            context: context,
          );
        }
        if (_nameFormKey.currentState?.validate() ?? false) {
          await context.read<UserRegistrationCubit>().saveNameTab(
                username: _userNameController.text,
                gender: _genderController.text,
                myPlace: _myPlaceController.text,
                profilePictureFile: _image!,
              );
        }
        break;
      case 1:
        await context.read<UserRegistrationCubit>().saveAgeTab(
              age: _age ?? 16,
              languages: _languages,
            );

        break;
      case 2:
        if (_bioFormKey.currentState?.validate() ?? false) {
          await context.read<UserRegistrationCubit>().saveBioTab(
                bio: _bioTextEditingController.text,
              );
        }

        break;
      case 3:
        if (_hobbies.isEmpty) return;
        await context.read<UserRegistrationCubit>().saveHobbiesTab(
              hobbies: _hobbies,
            );
        // Canceling timer so it will not call set state of destroyed page
        _timer?.cancel();

        if (!mounted) return;
        if (FirebaseAuth.instance.currentUser != null) {
          PostUserRegisterRoute(
            userId: FirebaseAuth.instance.currentUser!.uid,
            userPictureUrl: _imageUrl ?? '',
          ).go(context);
        } else {
          getIt<BannerService>().showErrorBanner(
            context: context,
            message: ErrorUtility.getErrorMessage(
              context,
              const BaseApiError<AuthErrorReason>(
                reason: AuthErrorReason.unauthenticatedUser,
              ),
            ),
          );
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const StyledAppBar(),
      body: SafeArea(
        child: BlocListener<UserRegistrationCubit, UserRegistrationState>(
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
                  message: RegistrationErrorUtility.getAuthErrorMessage(
                    context,
                    value.error,
                  ),
                  context: context,
                );
              },
              userDataLoaded: (state) {
                // Populate UI with the loaded user data
                setState(() {
                  _isLoading = false;
                });
                final user = state.user;

                _userNameController.text = user.username ?? '';
                _genderController.text = user.information?.gender ?? '';
                _myPlaceController.text = user.information?.myPlace ?? '';
                _languages
                  ..clear()
                  ..addAll(user.information?.languages ?? []);
                _hobbies
                  ..clear()
                  ..addAll(user.information?.hobbies ?? []);
                _age = user.information?.age;
                _imageUrl = user.information?.profilePictureUrl;

                _tabController = TabController(
                  length: 4,
                  vsync: this,
                  initialIndex:
                      user.lastRegistrationStepIndex.clamp(0, _tabs.length - 1),
                );
              },
              submittingSuccess: (state) {
                setState(() {
                  _isLoading = false;
                });
                _userNameController.text = state.user.username ?? '';
                _genderController.text = state.user.information?.gender ?? '';
                _myPlaceController.text = state.user.information?.myPlace ?? '';
                _languages
                  ..clear()
                  ..addAll(state.user.information?.languages ?? []);
                _age = state.user.information?.age;
                _imageUrl = state.user.information?.profilePictureUrl;
                _hobbies
                  ..clear()
                  ..addAll(state.user.information?.hobbies ?? []);

                if ((state.user.lastRegistrationStepIndex) + 1 < _tabs.length) {
                  _tabController?.animateTo(
                    state.user.lastRegistrationStepIndex,
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
                ) // Show loading until data is ready
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
                            NameTab(
                              formKey: _nameFormKey,
                              onButtonStateChange: _onNameTabButtonStateChange,
                              userNameController: _userNameController,
                              genderController: _genderController,
                              myPlaceController: _myPlaceController,
                              onImagePicked: setImagePicked,
                              scrollController: _scrollController,
                              imageUrl: _imageUrl,
                              initialImageFile: _image,
                              isValidGender: _isValidGender,
                              isValidPlace: _isValidPlace,
                              onGenderValidChange: (isValid) {
                                _isValidGender = isValid;
                                _validateInput();
                              },
                              onPlaceValidChange: (isValid) {
                                _isValidPlace = isValid;
                                _validateInput();
                              },
                            ),
                            AgeTab(
                              onButtonStateChange: _onNameTabButtonStateChange,
                              languages: _languages,
                              age: _age,
                              imageUrl: _imageUrl,
                              setAge: (age) => _age = age,
                              languageTextEditingController:
                                  languageTextEditingController,
                              formKey: _ageFormKey,
                              addLanguage: (language) {
                                setState(() {
                                  _languages.add(language);
                                });
                              },
                              scrollController: _scrollController,
                              name: _userNameController.text,
                            ),
                            BioTab(
                              onButtonStateChange: _onNameTabButtonStateChange,
                              formKey: _bioFormKey,
                              bioController: _bioTextEditingController,
                              imageUrl: _imageUrl,
                              scrollController: _scrollController,
                            ),
                            HobbiesTab(
                              hobbies: _hobbies,
                              formKey: _hobbiesFormKey,
                              hobbiesTextEditingController:
                                  _hobbiesTextEditingController,
                              assignHobbies: (hobby) {
                                setState(() {
                                  _hobbies = hobby;
                                });
                              },
                              removeHobby: (hobby) {
                                setState(() {
                                  _hobbies.removeWhere(
                                    (value) => value == hobby,
                                  );
                                });
                              },
                              onButtonStateChange: _onNameTabButtonStateChange,
                              imageUrl: _imageUrl,
                              name: _userNameController.text,
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
