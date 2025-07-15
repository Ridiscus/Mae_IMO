part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final CustomerModel? userModel;
  final bool? loading;
  final Failure? failure;

  const AuthState({this.userModel, this.loading, this.failure});

  AuthState copyWith({
    CustomerModel? userModel,
    bool? loading,
    Failure? failure,
  }) => AuthState(
    loading: loading ?? this.loading,
    userModel: userModel ?? this.userModel,
    failure: failure ?? this.failure,
  );

  factory AuthState.fromJson(Map<String, dynamic> json) => AuthState(
    userModel:
        json["user"] == null ? null : CustomerModel.fromMap(json["user"]),
  );

  Map<String, dynamic> toJson() => {"user": userModel?.toJson()};

  @override
  List<Object?> get props => [userModel, loading, failure];
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
