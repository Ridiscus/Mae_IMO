part of 'index.dart';

class AgencyModel {
  final int? id;
  final String? codeId;
  final String? name;
  final String? email;
  final String? commune;
  final String? password;
  final dynamic passwordResetToken;
  final dynamic passwordResetExpires;
  final String? contact;
  final String? adresse;
  final String? rccm;
  final String? rccmFile;
  final String? dfe;
  final String? dfeFile;
  final String? rib;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgencyModel({
    this.id,
    this.codeId,
    this.name,
    this.email,
    this.commune,
    this.password,
    this.passwordResetToken,
    this.passwordResetExpires,
    this.contact,
    this.adresse,
    this.rccm,
    this.rccmFile,
    this.dfe,
    this.dfeFile,
    this.rib,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  AgencyModel copyWith({
    int? id,
    String? codeId,
    String? name,
    String? email,
    String? commune,
    String? password,
    dynamic passwordResetToken,
    dynamic passwordResetExpires,
    String? contact,
    String? adresse,
    String? rccm,
    String? rccmFile,
    String? dfe,
    String? dfeFile,
    String? rib,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AgencyModel(
    id: id ?? this.id,
    codeId: codeId ?? this.codeId,
    name: name ?? this.name,
    email: email ?? this.email,
    commune: commune ?? this.commune,
    password: password ?? this.password,
    passwordResetToken: passwordResetToken ?? this.passwordResetToken,
    passwordResetExpires: passwordResetExpires ?? this.passwordResetExpires,
    contact: contact ?? this.contact,
    adresse: adresse ?? this.adresse,
    rccm: rccm ?? this.rccm,
    rccmFile: rccmFile ?? this.rccmFile,
    dfe: dfe ?? this.dfe,
    dfeFile: dfeFile ?? this.dfeFile,
    rib: rib ?? this.rib,
    profileImage: profileImage ?? this.profileImage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory AgencyModel.fromJson(String str) =>
      AgencyModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AgencyModel.fromMap(Map<String, dynamic> json) => AgencyModel(
    id: json["id"],
    codeId: json["code_id"],
    name: json["name"],
    email: json["email"],
    commune: json["commune"],
    password: json["password"],
    passwordResetToken: json["password_reset_token"],
    passwordResetExpires: json["password_reset_expires"],
    contact: json["contact"],
    adresse: json["adresse"],
    rccm: json["rccm"],
    rccmFile: json["rccm_file"],
    dfe: json["dfe"],
    dfeFile: json["dfe_file"],
    rib: json["rib"],
    profileImage: json["profile_image"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "code_id": codeId,
    "name": name,
    "email": email,
    "commune": commune,
    "password": password,
    "password_reset_token": passwordResetToken,
    "password_reset_expires": passwordResetExpires,
    "contact": contact,
    "adresse": adresse,
    "rccm": rccm,
    "rccm_file": rccmFile,
    "dfe": dfe,
    "dfe_file": dfeFile,
    "rib": rib,
    "profile_image": profileImage,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
