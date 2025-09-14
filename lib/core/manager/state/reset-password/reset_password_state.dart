part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  final bool isLoading;
  final bool? emailSent;
  final Failure? failure;

  const ResetPasswordState({
    this.isLoading = false,
    this.emailSent,
    this.failure,
  });

  ResetPasswordState copyWith({
    bool? isLoading,
    bool? emailSent,
    Failure? failure,
  }) => ResetPasswordState(
    isLoading: isLoading ?? this.isLoading,
    emailSent: emailSent,
    failure: failure,
  );

  @override
  List<Object?> get props => [isLoading, emailSent, failure];
}

final class ResetPasswordInitial extends ResetPasswordState {
  @override
  List<Object> get props => [];
}
