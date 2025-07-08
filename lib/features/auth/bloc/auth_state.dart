part of 'auth_bloc.dart';

@immutable
sealed class AuthState{}

final class AuthInitial extends AuthState{}

/// For Login State
final class AuthLoginLoading extends AuthState{}

final class AuthLoginSuccess extends AuthState{
  final UserModel response;
  AuthLoginSuccess({required this.response});
}

final class AuthLoginFailure extends AuthState{
  final String message;
  final int? status;

  AuthLoginFailure( {required this.message, this.status});
}

/// Logout user
final class AuthLogoutLoading extends AuthState{}

final class AuthLogoutSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthLogoutSuccess({required this.response});
}

final class AuthLogoutFailure extends AuthState{
  final String message;
  final int? status;

  AuthLogoutFailure( {required this.message, this.status});
}

/// Get user
final class AuthGetUserLoading extends AuthState{}

final class AuthGetUserSuccess extends AuthState{
  final UserModel response;
  AuthGetUserSuccess({required this.response});
}

enum AuthErrorType {
  unauthorized,     // 401 errors
  noInternet,       // Connection errors
  serverError,      // 500 errors
  unexpectedError   // Other errors
}

final class AuthGetUserFailure extends AuthState {
  final String message;
  final int? status;
  final AuthErrorType errorType;

  AuthGetUserFailure({
    required this.message,
    this.status,
    this.errorType = AuthErrorType.unexpectedError
  });
}

/// Update FCM Token
final class AuthUpdateFCMLoading extends AuthState{}

final class AuthUpdateFCMSuccess extends AuthState{
  final Map<String, dynamic> response;
  AuthUpdateFCMSuccess({required this.response});
}

final class AuthUpdateFCMFailure extends AuthState{
  final String message;
  final int? status;

  AuthUpdateFCMFailure( {required this.message, this.status});
}
