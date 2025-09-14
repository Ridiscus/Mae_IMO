part of 'index.dart';

class ForgotPasswordRequest extends Dto {
  final String codeId;

  ForgotPasswordRequest({required this.codeId});

  @override
  Map<String, dynamic> toJson() {
    return {"code_id": codeId};
  }
}
