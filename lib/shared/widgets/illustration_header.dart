part of 'index.dart';

/// Un composant pour afficher des illustrations décoratives d'arrière-plan
/// dans les en-têtes d'écrans, comme des cercles ou formes géométriques.
class IllustrationHeader extends StatelessWidget {
  /// La couleur de base des illustrations
  final Color color;

  /// L'opacité des éléments principaux
  final double primaryAlpha;

  /// L'opacité des éléments secondaires
  final double secondaryAlpha;

  /// Indique si les illustrations doivent être affichées à droite ou à gauche
  final bool alignRight;

  const IllustrationHeader({
    super.key,
    this.color = Colors.white,
    this.primaryAlpha = 0.07,
    this.secondaryAlpha = 0.03,
    this.alignRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          right: alignRight ? 0 : null,
          left: alignRight ? null : 0,
          child: CircleAvatar(
            backgroundColor: color.withValues(alpha: primaryAlpha),
            radius: 50.sp,
          ),
        ),
        Positioned(
          top: 60.sp,
          right: alignRight ? 0 : null,
          left: alignRight ? null : 0,
          child: CircleAvatar(
            backgroundColor: color.withValues(alpha: secondaryAlpha),
            radius: 100.sp,
          ),
        ),
      ],
    );
  }
}
