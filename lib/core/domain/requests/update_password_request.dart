part of 'index.dart';

class UpdatePasswordRequest extends Dto {
  final String password;
  final String newPassword;

  UpdatePasswordRequest({required this.password, required this.newPassword});

  @override
  Map<String, dynamic> toJson() {
    return {
      "current_password": password,
      "new_password": newPassword,
      "new_password_confirmation": newPassword,
    };
  }
}
