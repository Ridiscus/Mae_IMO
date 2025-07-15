part of 'index.dart';

class LoginRequest extends Dto {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {"username": username, "password": password};
  }
}
