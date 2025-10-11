part of 'index.dart';

class VerifyCodeEtatLieuxRequest extends Dto {
  final int locataireId;
  final String verificationCode;

  VerifyCodeEtatLieuxRequest({
    required this.locataireId,
    required this.verificationCode,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "locataire_id": locataireId,
      "verification_code": verificationCode,
    };
  }
}
