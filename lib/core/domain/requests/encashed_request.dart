part of 'index.dart';

class EncashedRequest extends Dto {
  final int locataireId;
  final int nombreMois;

  EncashedRequest({required this.locataireId, required this.nombreMois});

  @override
  Map<String, dynamic> toJson() {
    return {"locataire_id": locataireId, "nombre_mois": nombreMois};
  }
}
