part of 'index.dart';

class AmenityChip extends StatelessWidget {
  final List<AmenityModel> amenities;
  final double spacing;
  final double runSpacing;

  const AmenityChip({
    super.key,
    required this.amenities,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing.r,
      runSpacing: runSpacing.r,
      children:
          amenities
              .map(
                (amenity) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForAmenity(amenity.text),
                        size: 14.r,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.r),
                      Text(
                        amenity.text,
                        style:
                            TextStyle(
                              fontSize: 12.r,
                              color: Colors.grey[700],
                            ).sourceSansProRegular,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  /// Retourne l'icône appropriée basée sur le texte de l'équipement
  IconData _getIconForAmenity(String amenityText) {
    final text = amenityText.toLowerCase();

    if (text.contains('chambre')) {
      return Icons.bed_outlined;
    } else if (text.contains('toilette') ||
        text.contains('douche') ||
        text.contains('salle de bain')) {
      return Icons.shower_outlined;
    } else if (text.contains('garage')) {
      return Icons.garage_outlined;
    } else if (text.contains('m²') || text.contains('superficie')) {
      return Icons.square_foot_outlined;
    } else if (text.contains('cuisine')) {
      return Icons.kitchen_outlined;
    } else if (text.contains('salon') || text.contains('séjour')) {
      return Icons.chair_outlined;
    } else if (text.contains('balcon') || text.contains('terrasse')) {
      return Icons.balcony_outlined;
    } else if (text.contains('piscine')) {
      return Icons.pool_outlined;
    } else if (text.contains('jardin')) {
      return Icons.grass_outlined;
    } else if (text.contains('parking')) {
      return Icons.local_parking_outlined;
    } else {
      return Icons.home_outlined;
    }
  }
}
