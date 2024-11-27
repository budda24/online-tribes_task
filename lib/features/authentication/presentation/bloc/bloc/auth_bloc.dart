// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';
import 'package:online_tribes/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:online_tribes/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:online_tribes/features/authentication/presentation/bloc/bloc/auth_event.dart';
import 'package:online_tribes/features/authentication/presentation/bloc/bloc/auth_state.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/get_user_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/save_user_usecase.dart';
import 'package:online_tribes/features/user_registration/domain/entities/user_registration_step_enum.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignOutUseCase signOutUseCase;
  final SaveUserUseCase saveUserUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final GetUserUseCase getUserUseCase;
  final LoggerService loggerService;

  AuthBloc({
    required this.signOutUseCase,
    required this.saveUserUseCase,
    required this.signInWithGoogleUseCase,
    required this.getUserUseCase,
    required this.loggerService,
  }) : super(const AuthState.initial()) {
    on<AuthEvent>(
      (event, emit) async {
        await event.map(
          signOutRequested: (value) async {
            emit(const AuthState.loading());
            final failureOrResult = await signOutUseCase();
            emit(
              failureOrResult.fold(
                (failure) {
                  return AuthState.failure(failure);
                },
                (_) {
                  return const AuthState.unauthenticated();
                },
              ),
            );
          },
          googleSignInRequested: (event) async {
            try {
              emit(const AuthState.loading());
              final response = await signInWithGoogleUseCase();

              await response.fold(
                (failure) {
                  emit(AuthState.failure(failure));
                },
                (userCredentials) async {
                  if (userCredentials.additionalUserInfo?.isNewUser ?? false) {
                    //create empty user with sub classes constructed for the use of copyWith
                    final emptyUser = UserModel.empty();
                    final newUser = emptyUser.copyWith(
                      lastRegistrationStepIndex:
                          UserRegistrationStep.name.index,
                      userId: userCredentials.user!.uid,
                      email: userCredentials.user?.email ?? '',
                    );
                    final saveUserResult = await saveUserUseCase(
                      newUser,
                    );

                    saveUserResult.fold(
                      (error) {
                        emit(AuthState.failure(error));
                      },
                      (user) {
                        emit(AuthState.signedUpWithGoogle(newUser));
                      },
                    );
                  } else {
                    final getUserResult =
                        await getUserUseCase(userCredentials.user!.uid);
                    getUserResult.fold(
                      (error) {
                        emit(AuthState.failure(error));
                      },
                      (user) {
                        emit(
                          AuthState.loggedInWithGoogle(user),
                        );
                      },
                    );
                  }
                },
              );
            } catch (e) {
              emit(
                const AuthState.failure(
                  BaseApiError<AuthErrorReason>(
                    reason: AuthErrorReason.unknownError,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
