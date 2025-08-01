part of 'index.dart';

class IconButtonMenu extends StatelessWidget {
  final VoidCallback onPressed;
  final String? svgIcon;
  final String? title;
  final IconData? iconData;
  final bool selected;

  const IconButtonMenu({
    super.key,
    required this.onPressed,
    this.svgIcon,
    this.iconData,
    this.selected = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Column(
        children: [
          CircleAvatar(
            backgroundColor: selected ? Colors.transparent : Colors.transparent,
            radius: 16.sp,
            child: Icon(
              iconData,
              color: selected ? Colors.white : Colors.black,
              size: 23.sp,
              // width: 21,
              // height: 21,
            ),
          ),
          if (title?.isNotEmpty ?? false)
            Text(
              "$title",
              style:
                  TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ).sourceSansProSemiBold,
            ),
        ],
      ),
      onPressed: onPressed,
      highlightColor: Colors.transparent,
    );
  }
}
