part of 'index.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback onPressed;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image with rounded corners at top
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Row(children: [
                      ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      child: Image.asset(
                        property.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    ,
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      child: Image.asset(
                        property.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    ],),
                  ),
                  // Pagination indicators
                  Positioned(
                    bottom: 10.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        property.imageCount,
                        (index) => _buildPaginationDot(index == 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Property details
            const CustomSpacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ).sourceSansProSemiBold,
                ),
                SizedBox(height: 12.r),
                _buildAmenities(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationDot(bool isActive) {
    return PaginationDot(isActive: isActive);
  }

  Widget _buildAmenities() {
    return Wrap(
      spacing: 8.r,
      runSpacing: 8.r,
      children: property.amenities.map((amenity) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shower_outlined, size: 14.r, color: Colors.grey), // À remplacer par l'icône dynamique
              SizedBox(width: 4.r),
              Text(
                amenity.text,
                style: TextStyle(
                  fontSize: 12.r,
                  color: Colors.grey,
                ).sourceSansProRegular,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
