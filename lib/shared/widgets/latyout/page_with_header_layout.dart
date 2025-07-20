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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor ?? AppColors.scaffold,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppHeaderLayout(
              backgroundColor: headerBackgroundColor,
              padding: headerPadding,
              roundedBottomCorners: roundedBottomCorners,
              content: headerContent,
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButton != null ? floatingActionButtonLocation : null,
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      // color: bodyBackgroundColor ?? AppColors.scaffold,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),

              child: Padding(
                padding: bodyPadding ?? EdgeInsets.all(16.sp),
                child: bodyContent,
              ),
            ),
          );
        },
      ),
    );
  }
}
