part of 'index.dart';

class CommercialModel extends UserModel {
  // Propriétés spécifiques à CommercialModel
  final String? userTypeString;

  // Implémentation du polymorphisme
  @override
  UserType get userType => UserType.commercial;

  CommercialModel({
    // Propriétés héritées de UserModel
    super.id,
    super.codeId,
    super.name,
    super.prenom,
    super.email,
    super.passwordResetToken,
    super.passwordResetExpires,
    super.contact,
    super.profileImage,
    super.agenceId,
    super.proprietaireId,
    super.createdAt,
    super.updatedAt,
    // Propriétés spécifiques
    this.userTypeString,
  });

  CommercialModel copyWith({
    int? id,
    String? codeId,
    String? name,
    String? prenom,
    String? email,
    dynamic passwordResetToken,
    dynamic passwordResetExpires,
    String? contact,
    dynamic profileImage,
    String? agenceId,
    dynamic proprietaireId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userTypeString,
  }) =>
      CommercialModel(
        id: id ?? this.id,
        codeId: codeId ?? this.codeId,
        name: name ?? this.name,
        prenom: prenom ?? this.prenom,
        email: email ?? this.email,
        passwordResetToken: passwordResetToken ?? this.passwordResetToken,
        passwordResetExpires: passwordResetExpires ?? this.passwordResetExpires,
        contact: contact ?? this.contact,
        profileImage: profileImage ?? this.profileImage,
        agenceId: agenceId ?? this.agenceId,
        proprietaireId: proprietaireId ?? this.proprietaireId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userTypeString: userTypeString ?? this.userTypeString,
      );

  factory CommercialModel.fromJson(String str) => CommercialModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommercialModel.fromMap(Map<String, dynamic> json) {
    final baseFields = UserModel.parseBaseFields(json);
    return CommercialModel(
      // Champs de base hérités
      id: baseFields['id'],
      codeId: baseFields['codeId'],
      name: baseFields['name'] ?? baseFields['nom'],
      prenom: baseFields['prenom'],
      email: baseFields['email'],
      passwordResetToken: baseFields['passwordResetToken'],
      passwordResetExpires: baseFields['passwordResetExpires'],
      contact: baseFields['contact'],
      profileImage: baseFields['profileImage'],
      agenceId: baseFields['agenceId'],
      proprietaireId: baseFields['proprietaireId'],
      createdAt: baseFields['createdAt'],
      updatedAt: baseFields['updatedAt'],
      // Champs spécifiques à CommercialModel
      userTypeString: json["user_type"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = getBaseMap();
    baseMap.addAll({
      "user_type": userType.value,
    });
    return baseMap;
  }
}
