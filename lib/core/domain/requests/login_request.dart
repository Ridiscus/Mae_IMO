part of 'index.dart';

class LoginRequest extends Dto {
  final String codeId;
  final String password;

  LoginRequest({required this.codeId, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {"code_id": codeId, "password": password};
  }
}
