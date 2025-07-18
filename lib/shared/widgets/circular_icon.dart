part of 'index.dart';

/// Widget réutilisable qui affiche une icône SVG dans un cercle blanc
/// avec la possibilité d'ajouter une action onTap.
class CircularIcon extends StatelessWidget {
  /// Chemin vers l'asset SVG à afficher
  final String iconAsset;
  
  /// Fonction appelée lors du tap sur l'icône
  final VoidCallback? onPressed;
  
  /// Taille de l'icône (largeur et hauteur)
  final double? iconSize;
  
  /// Couleur du cercle de fond
  final Color backgroundColor;
  
  /// Padding autour de l'icône
  final double? padding;

  const CircularIcon({
    super.key,
    required this.iconAsset,
    this.onPressed,
    this.iconSize,
    this.backgroundColor = Colors.white,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(padding ?? 8.sp),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: SvgPicture.asset(
          iconAsset,
          width: iconSize ?? 24.sp,
          height: iconSize ?? 24.sp,
        ),
      ),
    );
  }
}
