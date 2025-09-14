part of 'index.dart';

class CustomCircleAvatarUser extends StatelessWidget {
  /// The profile image URL to display
  final String? profileImage;
  
  /// The size of the avatar (both width and height)
  final double size;
  
  /// Border color for the avatar
  final Color borderColor;
  
  /// Border width
  final double borderWidth;
  
  /// Icon size when no profile image is available
  final double iconSize;
  
  /// Background color when no profile image is available
  final Color backgroundColor;
  
  /// Icon color when no profile image is available
  final Color iconColor;

  const CustomCircleAvatarUser({
    super.key,
    this.profileImage,
    this.size = 72,
    this.borderColor = Colors.orange,
    this.borderWidth = 2,
    this.iconSize = 36,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth.r,
        ),
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all((size * 0.055).r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: profileImage != null
                ? DecorationImage(
                    image: UIHelper.cachedNetworkImageProvider(profileImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: profileImage == null
              ? CircleAvatar(
                  backgroundColor: backgroundColor,
                  child: Icon(
                    Icons.person,
                    size: iconSize.sp,
                    color: iconColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
