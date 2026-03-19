part of 'index.dart';

enum PropertyOwnerType { agency, owner }

class PropertyModel {
  final int? id;
  final String? numeroBien;
  final String? title;
  final String? type; // Appartement, Maison, Bureau, Studio, Magasin
  final double? price; // Loyer (FCFA)
  final String? location; // Adresse/Lieu précis
  final String? commune; // Commune d'Abidjan
  final double? superfice; // m2
  final int? nbPieces;
  final int? nbToilettes;
  final bool hasGarage;
  final String? utilizationType; // Habitation, Bureau, Commercial, Autre
  final String? customUtilization; // Si "Autre" est précisé

  // Conditions financières
  final int? nbMonthsAdvance;
  final int? nbMonthsCaution;
  final int? nbMonthsFrais;
  final double? totalAtEntry;
  final String? paymentDay;

  // Media & Info
  final String? mainImageUrl;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? image5;
  final String? videoUrl;
  final String? description;

  final OwnerModel? owner; // Informations complètes du propriétaire
  final DateTime? createdAt;
  final bool isAvailable;

  PropertyModel({
    this.id,
    this.numeroBien,
    this.title,
    this.type,
    this.price,
    this.location,
    this.commune,
    this.superfice,
    this.nbPieces,
    this.nbToilettes,
    this.hasGarage = false,
    this.utilizationType,
    this.customUtilization,
    this.nbMonthsAdvance,
    this.nbMonthsCaution,
    this.nbMonthsFrais,
    this.totalAtEntry,
    this.paymentDay,
    this.mainImageUrl,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.videoUrl,
    this.description,
    this.owner,
    this.createdAt,
    this.isAvailable = true,
  });

  String get formattedPrice => '${price?.toStringAsFixed(0) ?? "---"} FCFA';

  List<String> get supplementaryImages =>
      [
        image1,
        image2,
        image3,
        image4,
        image5,
      ].whereType<String>().where((s) => s.isNotEmpty).toList();

  PropertyModel copyWith({
    int? id,
    String? numeroBien,
    String? title,
    String? type,
    double? price,
    String? location,
    String? commune,
    double? superfice,
    int? nbPieces,
    int? nbToilettes,
    bool? hasGarage,
    String? utilizationType,
    String? customUtilization,
    int? nbMonthsAdvance,
    int? nbMonthsCaution,
    int? nbMonthsFrais,
    double? totalAtEntry,
    String? paymentDay,
    String? mainImageUrl,
    String? image1,
    String? image2,
    String? image3,
    String? image4,
    String? image5,
    String? videoUrl,
    String? description,
    OwnerModel? owner,
    DateTime? createdAt,
    bool? isAvailable,
  }) => PropertyModel(
    id: id ?? this.id,
    numeroBien: numeroBien ?? this.numeroBien,
    title: title ?? this.title,
    type: type ?? this.type,
    price: price ?? this.price,
    location: location ?? this.location,
    commune: commune ?? this.commune,
    superfice: superfice ?? this.superfice,
    nbPieces: nbPieces ?? this.nbPieces,
    nbToilettes: nbToilettes ?? this.nbToilettes,
    hasGarage: hasGarage ?? this.hasGarage,
    utilizationType: utilizationType ?? this.utilizationType,
    customUtilization: customUtilization ?? this.customUtilization,
    nbMonthsAdvance: nbMonthsAdvance ?? this.nbMonthsAdvance,
    nbMonthsCaution: nbMonthsCaution ?? this.nbMonthsCaution,
    nbMonthsFrais: nbMonthsFrais ?? this.nbMonthsFrais,
    totalAtEntry: totalAtEntry ?? this.totalAtEntry,
    paymentDay: paymentDay ?? this.paymentDay,
    mainImageUrl: mainImageUrl ?? this.mainImageUrl,
    image1: image1 ?? this.image1,
    image2: image2 ?? this.image2,
    image3: image3 ?? this.image3,
    image4: image4 ?? this.image4,
    image5: image5 ?? this.image5,
    videoUrl: videoUrl ?? this.videoUrl,
    description: description ?? this.description,
    owner: owner ?? this.owner,
    createdAt: createdAt ?? this.createdAt,
    isAvailable: isAvailable ?? this.isAvailable,
  );

  factory PropertyModel.fromMap(Map<String, dynamic> json) {
    return PropertyModel(
      id: json["id"],
      numeroBien: json["numero_bien"] ?? "N/A",
      title: json["type"] ?? "N/A",
      type: json["type"],
      price: double.tryParse(json["prix"]?.toString() ?? "0"),
      location: json["commune"] ?? "",
      commune: json["commune"],
      superfice: double.tryParse(json["superficie"]?.toString() ?? "0"),
      nbPieces: int.tryParse(json["nombre_de_chambres"]?.toString() ?? "0"),
      nbToilettes: int.tryParse(json["nombre_de_toilettes"]?.toString() ?? "0"),
      hasGarage:
          (json["garage"] == true ||
              json["garage"] == 1 ||
              json["garage"] == "1" ||
              json["garage"] == "Oui"),
      utilizationType: json["utilisation"] ?? "N/A",
      customUtilization: json["custom_utilization"],
      nbMonthsAdvance: int.tryParse(json["avance"]?.toString() ?? "1"),
      nbMonthsCaution: int.tryParse(json["caution"]?.toString() ?? "1"),
      nbMonthsFrais: int.tryParse(json["frais"]?.toString() ?? "1"),
      totalAtEntry: double.tryParse(json["montant_total"]?.toString() ?? "0"),
      paymentDay: json["date_fixe"] ?? "",
      mainImageUrl: json["image"] ?? "",
      image1: json["image1"],
      image2: json["image2"],
      image3: json["image3"],
      image4: json["image4"],
      image5: json["image5"],
      videoUrl: json["video_3d"] ?? "",
      description: json["description"] ?? "",
      owner:
          json["proprietaire"] != null
              ? OwnerModel.fromMap(json["proprietaire"])
              : null,
      createdAt:
          (json["created_at"] != null && json["created_at"] != "")
              ? DateTime.tryParse(json["created_at"])
              : null,
      isAvailable: (json["disponibilite"]?.toLowerCase() == "disponible"),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "numeroBien": numeroBien,
    "title": title,
    "type": type,
    "price": price,
    "location": location,
    "commune": commune,
    "superfice": superfice,
    "nb_pieces": nbPieces,
    "nb_toilettes": nbToilettes,
    "has_garage": hasGarage,
    "utilization_type": utilizationType,
    "custom_utilization": customUtilization,
    "nb_months_advance": nbMonthsAdvance,
    "nb_months_caution": nbMonthsCaution,
    "nb_months_frais": nbMonthsFrais,
    "total_at_entry": totalAtEntry,
    "payment_day": paymentDay,
    "main_image_url": mainImageUrl,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "image4": image4,
    "image5": image5,
    "video_url": videoUrl,
    "description": description,
    "proprietaire": owner?.toMap(),
    "created_at": createdAt?.toIso8601String(),
    "is_available": isAvailable,
  };
}
