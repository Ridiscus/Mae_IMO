part of 'index.dart';

class VisiteEstateRequest extends Dto {
  final int? bienId;
  final String? nom;
  final String? email;
  final String? telephone;
  final DateTime? dateVisite;
  final String? heureVisite;
  final String? message;

  VisiteEstateRequest({
    this.bienId,
    this.nom,
    this.email,
    this.telephone,
    this.dateVisite,
    this.heureVisite,
    this.message,
  });

  VisiteEstateRequest copyWith({
    int? bienId,
    String? nom,
    String? email,
    String? telephone,
    DateTime? dateVisite,
    String? heureVisite,
    String? message,
  }) => VisiteEstateRequest(
    bienId: bienId ?? this.bienId,
    nom: nom ?? this.nom,
    email: email ?? this.email,
    telephone: telephone ?? this.telephone,
    dateVisite: dateVisite ?? this.dateVisite,
    heureVisite: heureVisite ?? this.heureVisite,
    message: message ?? this.message,
  );

  @override
  Map<String, dynamic> toJson() => {
    "bien_id": bienId,
    "nom": nom,
    "email": email,
    "telephone": telephone,
    "date_visite":
        "${dateVisite!.year.toString().padLeft(4, '0')}-${dateVisite!.month.toString().padLeft(2, '0')}-${dateVisite!.day.toString().padLeft(2, '0')}",
    "heure_visite": heureVisite,
    "message": message,
  };
}
