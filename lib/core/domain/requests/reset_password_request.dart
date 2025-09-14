part of 'index.dart';

class ResetPasswordRequest extends Dto {
  final String token;
  final String codeId;
  final String type;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequest({
    required this.token,
    required this.codeId,
    required this.type,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "code_id": codeId,
      "type": type,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}
