part of 'index.dart';

class ResetPasswordRequest extends Dto {
  final String codeId;
  final String password;
  final String otp;

  ResetPasswordRequest({
    required this.codeId,
    required this.password,
    required this.otp,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "code_id": codeId,
      "otp": otp,
      "password": password,
      "password_confirmation": password,
      "type": "locataire"
    };
  }
}
