// ignore_for_file: non_constant_identifier_names

part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  AuthSignUp(this.userName, this.email, this.password, this.confirmPassword);
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;
  final String role;

  AuthSignIn(this.email, this.password, this.role);
}

final class AuthForgotPassword extends AuthEvent {
  final String email;

  AuthForgotPassword(this.email);
}

final class AuthGoogleSigning extends AuthEvent {}

final class AuthGoogleLinked extends AuthEvent {}

final class AuthLogout extends AuthEvent {}

final class AuthGetUser extends AuthEvent {}

final class AuthCompleteProfile extends AuthEvent {
  final String phoneNo;
  final String profileType;
  final String societyName;
  final String? blockName;
  final String? apartment;
  final String? ownershipStatus;
  final String? gateName;
  final String? startDate;
  final String? endDate;
  final File? tenantAgreement;
  final File? ownershipDocument;

  AuthCompleteProfile({
    required this.phoneNo,
    required this.profileType,
    required this.societyName,
    this.blockName,
    this.apartment,
    this.ownershipStatus,
    this.gateName,
    this.startDate,
    this.endDate,
    this.tenantAgreement,
    this.ownershipDocument,
  });
}

final class AuthAddApartment extends AuthEvent {
  final String societyName;
  final String societyBlock;
  final String apartment;
  final String role;

  AuthAddApartment({
    required this.societyName,
    required this.societyBlock,
    required this.apartment,
    required this.role,
  });
}

final class AuthAddGate extends AuthEvent {
  final String societyName;
  final String gateAssign;

  AuthAddGate({
    required this.societyName,
    required this.gateAssign,
  });
}

final class AuthUpdateFCM extends AuthEvent {
  final String FCMToken;

  AuthUpdateFCM({
    required this.FCMToken,
  });
}

final class AuthSocietyDetails extends AuthEvent {}

final class AuthGetContactEmail extends AuthEvent {}
