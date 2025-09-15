part of 'index.dart';

class TenantItemModel {
  final dynamic id;
  final String? name;
  final String? prenom;
  final String? email;
  final String? contact;

  TenantItemModel({this.name, this.prenom, this.email, this.contact, this.id});

  TenantItemModel copyWith({
    dynamic id,
    String? name,
    String? prenom,
    String? email,
    String? contact,
  }) => TenantItemModel(
    id: id ?? this.id,
    name: name ?? this.name,
    prenom: prenom ?? this.prenom,
    email: email ?? this.email,
    contact: contact ?? this.contact,
  );

  factory TenantItemModel.fromJson(String str) =>
      TenantItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TenantItemModel.fromMap(Map<String, dynamic> json) => TenantItemModel(
    id: json["id"],
    name: json["name"],
    prenom: json["prenom"],
    email: json["email"],
    contact: json["contact"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "prenom": prenom,
    "email": email,
    "contact": contact,
  };
}
