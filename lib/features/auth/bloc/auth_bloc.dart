import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:complaint_portal/features/auth/models/user_model.dart';

import '../../../utils/api_error.dart';
import '../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {

    on<AuthSignIn>((event, emit) async {
      emit(AuthLoginLoading());
      try {
        final UserModel response = await _authRepository.signInUser(
          email: event.email,
          password: event.password,
          role: event.role
        );
        emit(AuthLoginSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            AuthLoginFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(AuthLoginFailure(message: e.toString()));
        }
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLogoutLoading());
      try {
        final Map<String, dynamic> response = await _authRepository.logoutUser();
        emit(AuthLogoutSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            AuthLogoutFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(AuthLogoutFailure(message: e.toString()));
        }
      }
    });

    on<AuthGetUser>((event, emit) async {
      emit(AuthGetUserLoading());
      try {
        // Check for internet first
        bool hasInternet = await _checkInternetConnection();
        if (!hasInternet) {
          emit(
            AuthGetUserFailure(
              message: "No internet connection",
              errorType: AuthErrorType.noInternet,
            ),
          );
          return;
        }

        final UserModel response = await _authRepository.getUser();
        emit(AuthGetUserSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          if (e.statusCode == 401) {
            emit(
              AuthGetUserFailure(
                message: e.message.toString(),
                status: e.statusCode,
                errorType: AuthErrorType.unauthorized,
              ),
            );
          } else if (e.statusCode != null && e.statusCode! >= 500) {
            emit(
              AuthGetUserFailure(
                message: e.message.toString(),
                status: e.statusCode,
                errorType: AuthErrorType.serverError,
              ),
            );
          } else {
            emit(
              AuthGetUserFailure(
                message: e.message.toString(),
                status: e.statusCode,
                errorType: AuthErrorType.unexpectedError,
              ),
            );
          }
        } else if (e is SocketException || e.toString().contains('SocketException')) {
          emit(
            AuthGetUserFailure(
              message: "No internet connection",
              errorType: AuthErrorType.noInternet,
            ),
          );
        } else {
          emit(
            AuthGetUserFailure(
              message: e.toString(),
              errorType: AuthErrorType.unexpectedError,
            ),
          );
        }
      }
    });

    on<AuthUpdateFCM>((event, emit) async {
      emit(AuthUpdateFCMLoading());
      try {
        final Map<String, dynamic> response = await _authRepository.updateFCM(
          fcmToken: event.FCMToken,
        );
        emit(AuthUpdateFCMSuccess(response: response));
      } catch (e) {
        if (e is ApiError) {
          emit(
            AuthUpdateFCMFailure(
              message: e.message.toString(),
              status: e.statusCode,
            ),
          );
        } else {
          emit(AuthUpdateFCMFailure(message: e.toString()));
        }
      }
    });
  }

  AuthState getLatestState() {
    return state;
  }
}

Future<bool> _checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
