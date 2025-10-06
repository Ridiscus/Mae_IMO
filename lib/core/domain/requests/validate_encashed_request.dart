part of 'index.dart';

class ValidateEncashedRequest extends Dto {
  final int locataireId;
  final String code;
  final int nombreMois;

  ValidateEncashedRequest({
    required this.locataireId,
    required this.code,
    this.nombreMois = 1,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "locataire_id": locataireId,
      "code": code,
      "nombre_mois": nombreMois,
    };
  }
}
