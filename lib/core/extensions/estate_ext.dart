part of 'index.dart';

extension EstateExt on EstateModel {
  List<AmenityModel> get amenities {
    final List<AmenityModel> amenities = [];
    if (superficie != null) {
      amenities.add(AmenityModel(text: '$superficie M²')); // M\u00B2
    }
    if (nombreDeChambres != null) {
      amenities.add(AmenityModel(text: '$nombreDeChambres Chambre(s)'));
    }
    if (nombreDeToilettes != null) {
      amenities.add(AmenityModel(text: '$nombreDeToilettes Toilette(s)'));
    }
    if (garage != null &&
        (garage ?? "").isNotEmpty) {
      amenities.add(AmenityModel(text: 'Garage ${garage} '));
    }

    return amenities;
  }

  List<Map<String, dynamic>> get rooms {
    final List<Map<String, dynamic>> rooms = [
      {'name': 'Cuisine', "comment": "", 'status': null},
      {'name': 'Chambre principale', "comment": "", 'status': null},
      {'name': 'Chambre secondaire', "comment": "", 'status': null},
      {'name': 'Salle de bain', "comment": "", 'status': null},
    ];
    return rooms;
  }

  int get imageCount => (images ?? []).length;

  String get title => [type, commune].join(' / ').trim();
}
