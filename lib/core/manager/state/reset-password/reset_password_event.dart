part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
}

final class ForgotPasswordEvent extends ResetPasswordEvent {
  final ForgotPasswordRequest dto;

  const ForgotPasswordEvent({required this.dto});

  @override
  List<Object> get props => [dto];
}
