part of 'index.dart';

class ScrollableBodyWidget extends StatelessWidget {
  final Widget bodyContent;
  final EdgeInsetsGeometry? bodyPadding;

  const ScrollableBodyWidget({
    super.key,
    required this.bodyContent,
    this.bodyPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
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
      ),
    );
  }
}
