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
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        // color: bodyBackgroundColor ?? AppColors.scaffold,
        child: RefreshIndicator.adaptive(
          onRefresh: onRefresh != null ? onRefresh! : () => Future.value(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
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
      ),
    );
  }
}
