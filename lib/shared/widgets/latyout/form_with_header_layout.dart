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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(context),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * .22,
            child: _buildFormContainer(context),
          ),
        ],
      ),
    );
  }

  /// Builds the colored header section with a back button and title.
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 24.sp),
      width: double.infinity,
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircularBackButton(onPressed: onBackPressed),
            CustomSpacer(),
            Text(
              headerTitle,
              style:
                  TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).sourceSansProBold,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the white rounded container for the form.
  Widget _buildFormContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16.sp),
      decoration: BoxDecoration(
        color: contentColor ?? Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.sp),
          topRight: Radius.circular(30.sp),
        ),
      ),
      padding: EdgeInsets.all(24.sp),
      child: content,
    );
  }
}
