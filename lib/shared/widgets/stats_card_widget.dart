part of 'index.dart';

class StatsCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;
  final Color iconBackgroundColor;
  final Color arrowColor;
  final Color valueColor;
  final VoidCallback onTap;

  const StatsCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
    required this.iconBackgroundColor,
    required this.arrowColor,
    required this.valueColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 110.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: arrowColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              decoration: BoxDecoration(
                color: arrowColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
              child: Center(
                child: Icon(iconData, color: arrowColor, size: 30.sp),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.black,
                          ).sourceSansProSemiBold,
                    ),

                    Text(
                      value,
                      style:
                          TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: valueColor,
                          ).sourceSansProBold,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
