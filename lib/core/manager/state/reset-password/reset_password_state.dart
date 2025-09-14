part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  final bool isLoading;
  final bool? emailSent;
  final bool? passwordReset;
  final Failure? failure;

  const ResetPasswordState({
    this.isLoading = false,
    this.emailSent,
    this.passwordReset,
    this.failure,
  });

  ResetPasswordState copyWith({
    bool? isLoading,
    bool? emailSent,
    bool? passwordReset,
    Failure? failure,
  }) => ResetPasswordState(
    isLoading: isLoading ?? this.isLoading,
    emailSent: emailSent,
    passwordReset: passwordReset,
    failure: failure,
  );

  @override
  List<Object?> get props => [isLoading, emailSent, passwordReset, failure];
}

final class ResetPasswordInitial extends ResetPasswordState {
  @override
  List<Object> get props => [];
}
