part of 'index.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int)? onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    this.selectedIndex = 0,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onCategorySelected?.call(index),
            child: Container(
              margin: EdgeInsets.only(left: 8.r),
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orange : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected 
                      ? Colors.transparent
                      : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 16.sp,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: isSelected ? Colors.white : Colors.grey,
                    ).sourceSansProSemiBold,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
