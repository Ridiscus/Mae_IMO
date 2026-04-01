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

  /// Padding autour du contenu de l'entête (back button + titre).
  /// Par défaut : EdgeInsets.only(left: 0, right: 16).
  final EdgeInsets? headerPadding;

  /// Taille de la police du titre dans l'entête.
  /// Par défaut : 24.sp.
  final double? headerTitleSize;

  /// Creates a form with header layout.
  const FormWithHeaderLayout({
    super.key,
    required this.headerTitle,
    required this.content,
    this.contentColor,
    this.onBackPressed,
    this.padding,
    this.headerPadding,
    this.headerTitleSize,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(context, screenHeight),
            ),
            // Form Content
            Positioned.fill(
              top: (screenHeight * .22).sp,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: _buildFormContainer(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the colored header section with a back button and title.
  Widget _buildHeader(BuildContext context, double screenHeight) {
    return AppHeaderLayout(
      height: (screenHeight * .28).sp,
      bottomRadius: 30.sp,
      alignRight: true,
      content: SafeArea(
        bottom: false,
        child: Padding(
          padding: headerPadding ?? EdgeInsets.only(left: 0.sp, right: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularBackButton(onPressed: onBackPressed),
              SizedBox(height: 32.sp),
              Flexible(
                child: Text(
                  headerTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(
                        fontSize: headerTitleSize ?? 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ).sourceSansProBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the white rounded container for the form.
  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.sp),
      clipBehavior: Clip.antiAlias,
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
