part of 'index.dart';

class SaveEstateLocationRequest extends Dto {
  final int locataireId;
  final int bienId;
  final String typeBien;
  final String communeBien;
  final String presencePartie;
  final Map<String, dynamic> partiesCommunes;
  final List<Map<String, dynamic>> chambres;
  final int nombreCle;

  SaveEstateLocationRequest({
    required this.locataireId,
    required this.bienId,
    required this.typeBien,
    required this.communeBien,
    required this.presencePartie,
    required this.partiesCommunes,
    required this.chambres,
    required this.nombreCle,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "locataire_id": locataireId,
      "bien_id": bienId,
      "type_bien": typeBien,
      "commune_bien": communeBien,
      "presence_partie": presencePartie,
      "parties_communes": partiesCommunes,
      "chambres": chambres,
      "nombre_cle": nombreCle,
    };
  }
}
