part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final bool isLoading;
  final Failure? failure;

  const AuthState({this.userModel, this.isLoading = false, this.failure});

  AuthState copyWith({
    UserModel? userModel,
    bool? isLoading,
    Failure? failure,
  }) => AuthState(
    isLoading: isLoading ?? this.isLoading,
    userModel: userModel ?? this.userModel,
    failure: failure,
  );

  factory AuthState.fromJson(Map<String, dynamic> json) => AuthState(
    userModel: json["user"] == null ? null : UserModel.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"user": userModel?.toJson()};

  @override
  List<Object?> get props => [userModel, isLoading, failure];
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
