part of '../../widgets/index.dart';

/// A reusable layout for forms with a colored header section.
///
/// This layout is commonly used in authentication screens like login and password reset.
/// It consists of a colored header at the top containing a back button and a title,
/// and a white rounded form container below it.
class FormWithHeaderLayout extends StatelessWidget {
  /// The title displayed in the header section.
  final String headerTitle;

  /// The content to display in the form section.
  final Widget content;

  final Color? contentColor;
  final EdgeInsets? padding;

  /// Optional action to execute when the back button is pressed.
  /// If null, it will use the default Navigator.pop behavior.
  final VoidCallback? onBackPressed;

  /// Creates a form with header layout.
  const FormWithHeaderLayout({
    super.key,
    required this.headerTitle,
    required this.content,
    this.contentColor,
    this.onBackPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: AppColors.primary),
      child: Scaffold(
        body: Stack(
          children: [
            _buildHeader(context),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * .22,
              child: _buildFormContainer(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the colored header section with a back button and title.
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: Stack(
        children: [
          Positioned.fill(
            left: 12.sp,
            right: 12.sp,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircularBackButton(onPressed: onBackPressed),
                  CustomSpacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: Text(
                      headerTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          
                          TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ).sourceSansProBold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Utiliser le nouveau composant IllustrationHeader
          IllustrationHeader(
            color: Colors.white,
            primaryAlpha: 0.07,
            secondaryAlpha: 0.03,
            alignRight: true,
          ),
        ],
      ),
    );
  }

  /// Builds the white rounded container for the form.
  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.sp),
      decoration: BoxDecoration(
        color: contentColor ?? Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.sp),
          topRight: Radius.circular(30.sp),
        ),
      ),
      padding: padding ?? EdgeInsets.all(16.sp),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(child: content),
            ),
          );
        },
      ),
    );
  }
}
