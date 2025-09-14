part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class UserSignInEvent extends AuthEvent {
  final LoginRequest dto;

  const UserSignInEvent({required this.dto});

  @override
  List<Object> get props => [dto];
}

final class UpdateEmailEvent extends AuthEvent {
  final UpdateEmailRequest dto;

  const UpdateEmailEvent({required this.dto});

  @override
  List<Object> get props => [dto];
}

final class UpdatePasswordEvent extends AuthEvent {
  final UpdatePasswordRequest dto;

  const UpdatePasswordEvent({required this.dto});

  @override
  List<Object> get props => [dto];
}

final class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}
