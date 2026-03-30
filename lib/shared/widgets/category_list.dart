part of 'index.dart';

class CategoryList extends StatelessWidget {
  final List<EstateTypeModel> categories;
  final EstateTypeModel? selected;
  final Function(EstateTypeModel model)? onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    this.selected,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.select((EstateBloc state) => state.state);
    final bool isLoading = state.isLoading ?? false;
    final bool showSkeleton = isLoading && categories.isEmpty;

    if (categories.isEmpty && !isLoading) return const SizedBox.shrink();

    final List<EstateTypeModel> itemsToDisplay =
        showSkeleton
            ? List.generate(5, (_) => EstateTypeModel(type: 'Chargement'))
            : categories;

    return Skeletonizer(
      enabled: showSkeleton,
      child: Container(
        constraints: BoxConstraints(maxHeight: 45.h),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: itemsToDisplay.length,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          separatorBuilder: (context, index) => SizedBox(width: 8.r),
          itemBuilder: (context, index) {
            final isSelected =
                !showSkeleton && itemsToDisplay[index] == selected;
            return GestureDetector(
              onTap:
                  showSkeleton
                      ? null
                      : () => onCategorySelected?.call(itemsToDisplay[index]),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.orange : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color:
                        isSelected
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
                      itemsToDisplay[index].name,
                      style:
                          TextStyle(
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
      ),
    );
  }
}
