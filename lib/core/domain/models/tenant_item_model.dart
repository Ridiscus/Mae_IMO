part of 'index.dart';

class TenantItemModel {
  final dynamic id;
  final String? name;
  final String? nom;
  final String? prenom;
  final String? email;
  final String? contact;
  final String? typeBien;
  final String? communeBien;
  final String? dateEtatLieu;
  final String? statusEtatEntre;

  TenantItemModel({
    this.name,
    this.nom,
    this.prenom,
    this.email,
    this.contact,
    this.id,
    this.typeBien,
    this.communeBien,
    this.dateEtatLieu,
    this.statusEtatEntre,
  });

  TenantItemModel copyWith({
    dynamic id,
    String? name,
    String? prenom,
    String? nom,
    String? email,
    String? contact,
    String? typeBien,
    String? communeBien,
    String? dateEtatLieu,
    String? statusEtatEntre,
  }) => TenantItemModel(
    id: id ?? this.id,
    name: name ?? this.name,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    email: email ?? this.email,
    contact: contact ?? this.contact,
    typeBien: typeBien ?? this.typeBien,
    communeBien: communeBien ?? this.communeBien,
    dateEtatLieu: dateEtatLieu ?? this.dateEtatLieu,
    statusEtatEntre: statusEtatEntre ?? this.statusEtatEntre,
  );

  factory TenantItemModel.fromJson(String str) =>
      TenantItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TenantItemModel.fromMap(Map<String, dynamic> json) => TenantItemModel(
    id: json["id"],
    name: json["name"],
    nom: json["nom"],
    prenom: json["prenom"],
    email: json["email"],
    contact: json["contact"],
    typeBien: json['type_bien'],
    communeBien: json['commune_bien'],
    dateEtatLieu: json['date_etat_lieu'],
    statusEtatEntre: json['status_etat_entre'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "nom": nom,
    "prenom": prenom,
    "email": email,
    "contact": contact,
    "type_bien": typeBien,
    "commune_bien": communeBien,
    "date_etat_lieu": dateEtatLieu,
    "status_etat_entre": statusEtatEntre,
  };
}
