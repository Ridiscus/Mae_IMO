part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final bool isLoading;
  final bool? updatedEmail;
  final bool? updatedPassword;
  final bool? updatedImage;
  final Failure? failure;

  const AuthState({
    this.userModel,
    this.isLoading = false,
    this.failure,
    this.updatedEmail,
    this.updatedPassword,
    this.updatedImage,
  });

  AuthState copyWith({
    UserModel? userModel,
    bool? isLoading,
    Failure? failure,
    bool? updatedEmail,
    bool? updatedPassword,
    bool? updatedImage,
  }) => AuthState(
    isLoading: isLoading ?? this.isLoading,
    userModel: userModel ?? this.userModel,
    failure: failure,
    updatedEmail: updatedEmail,
    updatedPassword: updatedPassword,
    updatedImage: updatedImage,
  );

  factory AuthState.fromJson(Map<String, dynamic> json) => AuthState(
    userModel: json["user"] == null ? null : UserModel.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"user": userModel?.toJson()};

  @override
  List<Object?> get props => [userModel, isLoading, failure, updatedEmail];
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
