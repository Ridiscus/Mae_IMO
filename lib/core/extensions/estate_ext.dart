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
        (garage ?? "").isNotEmpty &&
        garage!.toUpperCase() == 'OUI') {
      amenities.add(AmenityModel(text: '1 Garage'));
    }

    return amenities;
  }
  int get imageCount => (images ?? []).length;

  String get title => [type, commune].join(' / ').trim();
}
