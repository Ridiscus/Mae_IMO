part of '../../widgets/index.dart';

/// A reusable layout for pages with a colored header and scrollable content.
///
/// This layout consists of a colored header at the top (using AppHeaderLayout)
/// and a scrollable content area below it. It provides a consistent structure
/// for pages across the application.
class PageWithHeaderLayout extends StatelessWidget {
  /// The header content to display in the colored header section.
  final Widget headerContent;

  /// The content to display in the main body of the page.
  final Widget bodyContent;

  /// The color of the header background. Default is AppColors.primary.
  final Color? headerBackgroundColor;

  /// The color of the body background. Default is AppColors.scaffold.
  final Color? bodyBackgroundColor;

  /// Padding to apply to the header content.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding to apply to the body content.
  final EdgeInsetsGeometry? bodyPadding;

  /// Whether to add rounded corners at the bottom of the header.
  final bool roundedBottomCorners;

  /// Optional floating action button to display at the bottom of the screen.
  final Widget? floatingActionButton;

  /// The position of the floating action button if provided.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Whether to wrap the body content in a scrollable view.
  final bool scrollableBody;

  final RefreshCallback? onRefresh;

  final double? headerHeight;

  /// Creates a page with header layout.
  const PageWithHeaderLayout({
    super.key,
    required this.headerContent,
    required this.bodyContent,
    this.headerBackgroundColor,
    this.bodyBackgroundColor,
    this.headerPadding,
    this.bodyPadding,
    this.roundedBottomCorners = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation =
        FloatingActionButtonLocation.centerFloat,
    this.scrollableBody = true,
    this.onRefresh,
    this.headerHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double computedHeaderHeight =
        headerHeight ?? (MediaQuery.of(context).size.height * .25).sp;
    final double bodyTopOffset = (computedHeaderHeight * 0.8).sp;

    return Scaffold(
      backgroundColor: bodyBackgroundColor ?? AppColors.scaffold,
      body: Stack(
        children: [
          // 1. Header background and content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeaderLayout(
              backgroundColor: headerBackgroundColor,
              padding: headerPadding,
              roundedBottomCorners: roundedBottomCorners,
              content: headerContent,
              height: computedHeaderHeight,
              bottomRadius: 30.r,
            ),
          ),

          // 2. Main body content
          Positioned.fill(
            top: bodyTopOffset,
            child: Container(
              decoration: BoxDecoration(
                color: bodyBackgroundColor ?? AppColors.scaffold,
                borderRadius:
                    roundedBottomCorners
                        ? BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r),
                        )
                        : null,
              ),
              clipBehavior: Clip.antiAlias,
              child: ScrollableBodyWidget(
                bodyContent: bodyContent,
                bodyPadding:
                    bodyPadding ?? EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 40.h),
                onRefresh: onRefresh,
                useExpanded:
                    false, // Correction : Désactive l'Expanded ici car nous sommes dans un Positioned
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButton != null ? floatingActionButtonLocation : null,
    );
  }
}
