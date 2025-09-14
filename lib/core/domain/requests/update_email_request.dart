part of 'index.dart';

class UpdateEmailRequest extends Dto {
  final String email;
  final String password;

  UpdateEmailRequest({required this.email, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {"new_email": email, "password": password};
  }
}
