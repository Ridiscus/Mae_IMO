part of 'index.dart';

class SearchBarWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSearchPressed;
  final bool showFilterButton;
  final Color? backgroundColor;
  final Color? filterButtonColor;
  final EdgeInsetsGeometry? padding;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Rechercher, Appartement, Villa',
    this.controller,
    this.onChanged,
    this.onFilterPressed,
    this.onSearchPressed,
    this.showFilterButton = true,
    this.backgroundColor = Colors.white,
    this.filterButtonColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.sp),
            child: GestureDetector(
              onTap: onSearchPressed,
              child: Icon(
                Icons.search,
                size: 24.sp,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(width: 8.sp),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor: backgroundColor,
                hintStyle: TextStyle(
                  fontSize: 14.r,
                  color: Colors.grey,
                ).sourceSansProRegular,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.r),
              ),
            ),
          ),
          if (showFilterButton)
            Padding(
              padding: EdgeInsets.only(right: 8.sp),
              child: GestureDetector(
                onTap: onFilterPressed,
                child: CircleAvatar(
                  backgroundColor: filterButtonColor ?? AppColors.orange,
                  child: SvgPicture.asset(
                    Assets.filter,
                    width: 15.sp,
                    height: 15.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
