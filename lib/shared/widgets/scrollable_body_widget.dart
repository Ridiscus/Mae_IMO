part of 'index.dart';

class ScrollableBodyWidget extends StatelessWidget {
  final Widget bodyContent;
  final EdgeInsetsGeometry? bodyPadding;
  final RefreshCallback? onRefresh;

  const ScrollableBodyWidget({
    super.key,
    required this.bodyContent,
    this.bodyPadding,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // On prépare le contenu scrollable
    // Le LayoutBuilder sert à s'assurer que le contenu prend au moins toute la hauteur de l'écran
    // (Utile pour les écrans "Vides" ou les formulaires courts)
    Widget scrollView = LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // --- LA LIGNE MAGIQUE ---
          // C'est ça qui permet de "tirer" l'écran même s'il y a peu de contenu
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: bodyPadding ?? EdgeInsets.symmetric(horizontal: 16.sp, vertical: 24.sp),
              child: bodyContent,
            ),
          ),
        );
      },
    );

    // On enveloppe tout ça dans un Expanded pour que ça prenne la place dans la PageWithHeaderLayout
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: onRefresh != null
            ? RefreshIndicator.adaptive(
          onRefresh: onRefresh!,
          color: Colors.white,           // Couleur de la flèche de chargement
          backgroundColor: AppColors.primary, // Couleur du fond du rond
          child: scrollView,
        )
            : scrollView, // Si pas de fonction refresh, on affiche juste le scroll
      ),
    );
  }
}