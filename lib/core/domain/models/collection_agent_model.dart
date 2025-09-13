part of 'index.dart';

class CollectionAgentModel extends UserModel {
  // Propriétés spécifiques à CollectionAgentModel
  final String? commune;
  final String? password;
  final DateTime? dateNaissance;
  final String? userTypeString; // Renommé pour éviter la confusion avec le getter userType

  // Implémentation du polymorphisme
  @override
  UserType get userType => UserType.collectionAgent;

  CollectionAgentModel({
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
    this.commune,
    this.password,
    this.dateNaissance,
    this.userTypeString,
  });

  CollectionAgentModel copyWith({
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
    String? commune,
    String? password,
    DateTime? dateNaissance,
    String? userTypeString,
  }) =>
      CollectionAgentModel(
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
        commune: commune ?? this.commune,
        password: password ?? this.password,
        dateNaissance: dateNaissance ?? this.dateNaissance,
        userTypeString: userTypeString ?? this.userTypeString,
      );

  factory CollectionAgentModel.fromJson(String str) => CollectionAgentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CollectionAgentModel.fromMap(Map<String, dynamic> json) {
    final baseFields = UserModel.parseBaseFields(json);
    return CollectionAgentModel(
      // Champs de base hérités
      id: baseFields['id'],
      codeId: baseFields['codeId'],
      name: baseFields['name'],
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
      // Champs spécifiques à CollectionAgentModel
      commune: json["commune"],
      password: json["password"],
      dateNaissance: json["date_naissance"] == null ? null : DateTime.parse(json["date_naissance"]),
      userTypeString: json["user_type"],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = getBaseMap();
    baseMap.addAll({
      "user_type": userType.value,
      "commune": commune,
      "password": password,
      "date_naissance": dateNaissance != null 
          ? "${dateNaissance!.year.toString().padLeft(4, '0')}-${dateNaissance!.month.toString().padLeft(2, '0')}-${dateNaissance!.day.toString().padLeft(2, '0')}"
          : null,
    });
    return baseMap;
  }
}
