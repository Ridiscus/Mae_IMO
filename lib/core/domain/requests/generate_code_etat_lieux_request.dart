part of 'index.dart';

class GenerateCodeEtatLieuxRequest extends Dto {
  final int locataireId;

  GenerateCodeEtatLieuxRequest({required this.locataireId});

  @override
  Map<String, dynamic> toJson() {
    return {"locataire_id": locataireId};
  }
}
