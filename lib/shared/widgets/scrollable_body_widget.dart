part of 'index.dart';

class ScrollableBodyWidget extends StatelessWidget {
  final Widget bodyContent;
  final EdgeInsetsGeometry? bodyPadding;
  final RefreshCallback? onRefresh;
  final bool useExpanded;

  const ScrollableBodyWidget({
    super.key,
    required this.bodyContent,
    this.bodyPadding,
    this.onRefresh,
    this.useExpanded =
        true, // Par défaut à true pour ne pas casser les pages existantes
  });

  @override
  Widget build(BuildContext context) {
    Widget scrollView = LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding:
                  bodyPadding ??
                  EdgeInsets.symmetric(horizontal: 16.sp, vertical: 24.sp),
              child: bodyContent,
            ),
          ),
        );
      },
    );

    Widget content = SizedBox(
      width: double.infinity,
      child:
          onRefresh != null
              ? RefreshIndicator.adaptive(
                onRefresh: onRefresh!,
                color: Colors.white,
                backgroundColor: AppColors.primary,
                child: scrollView,
              )
              : scrollView,
    );

    // Si useExpanded est vrai, on enveloppe dans Expanded (comportement d'origine)
    // Sinon on retourne juste le contenu (nécessaire pour PageWithHeaderLayout)
    return useExpanded ? Expanded(child: content) : content;
  }
}
