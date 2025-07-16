part of 'index.dart';

class PropertyModel {
  final String title;
  final String imageUrl;
  final List<AmenityModel> amenities;
  final int imageCount;

  PropertyModel({
    required this.title,
    required this.imageUrl,
    required this.amenities,
    this.imageCount = 3,
  });
}
