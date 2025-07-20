part of '../index.dart';

/// Model for representing an edit option in the profile page
class ProfileEditOption {
  /// The icon to display for the edit option
  final IconData icon;

  /// The title text of the edit option
  final String title;

  /// The callback function when the option is tapped
  final VoidCallback onTap;

  /// Optional trailing icon to display
  final IconData? trailingIcon;

  /// Creates a new edit option for profile page
  const ProfileEditOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingIcon,
  });
}

/// Model for representing contact information in the profile
class ProfileContactInfo {
  /// The icon to display next to the contact info
  final IconData icon;

  /// The text content of the contact info (email, phone, etc.)
  final String text;

  /// Creates a new contact info item
  const ProfileContactInfo({required this.icon, required this.text});
}

/// A reusable widget for displaying a profile page with header,
/// profile information, and edit options.
class ProfilePageLayout extends StatelessWidget {
  /// The user's display name
  final String userName;

  /// The user's ID to display
  final String userId;

  /// Optional callback for back button. If null, the back button will use context.pop()
  final VoidCallback? onBackPressed;

  /// Optional callback for logout button
  final VoidCallback onLogoutPressed;

  /// List of contact information to display (email, phone, etc.)
  final List<ProfileContactInfo> contactInfo;

  /// List of edit options to display in the bottom section
  final List<ProfileEditOption> editOptions;

  /// Background color for the profile section
  final Color? profileBackgroundColor;

  /// Creates a profile page layout
  const ProfilePageLayout({
    super.key,
    required this.userName,
    required this.userId,
    required this.onLogoutPressed,
    required this.contactInfo,
    required this.editOptions,
    this.onBackPressed,
    this.profileBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: profileBackgroundColor ?? AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: _buildProfileContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.r, right: 16.r),
      width: double.infinity,
      color: profileBackgroundColor ?? AppColors.primary,
      alignment: Alignment.centerLeft,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularBackButton(onPressed: onBackPressed),

            CircularSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Container(
      width: double.infinity,
      color: profileBackgroundColor ?? AppColors.primary,
      child: Column(
        children: [
          _buildProfileInfo(context), 
          _buildEditOptions(context)],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      decoration: BoxDecoration(
        color: profileBackgroundColor ?? AppColors.primary,
      ),
      child: Column(
        children: [
          CustomCircleAvatarUser(
            backgroundColor: Colors.grey[300]!,
            size: 120,
            iconColor: AppColors.black,
            iconSize: 60,
          ),
          CustomSpacer(),
          Text(
            userName,
            style:
                TextStyle(
                  fontSize: 24.r,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
          SizedBox(height: 4.r),
          Text(
            'ID : $userId',
            style:
                TextStyle(
                  fontSize: 16.r,
                  color: Colors.grey[300],
                ).sourceSansProRegular,
          ),
          SizedBox(height: 24.r),
          ...contactInfo.map(
            (info) => Padding(
              padding: EdgeInsets.only(bottom: 16.r),
              child: _buildContactInfoItem(info),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoItem(ProfileContactInfo info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(info.icon, size: 24.r, color: Colors.grey[300]),
        SizedBox(width: 16.r),
        Text(
          info.text,
          style:
              TextStyle(
                fontSize: 16.r,
                color: Colors.white,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildEditOptions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < editOptions.length; i++) ...[
            if (i > 0) _buildDivider(),
            _buildEditOptionItem(editOptions[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildEditOptionItem(ProfileEditOption option) {
    return InkWell(
      onTap: option.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.r),
        child: Row(
          children: [
            Icon(option.icon, size: 24.r, color: Colors.black87),
            SizedBox(width: 16.r),
            Expanded(
              child: Text(
                option.title,
                style:
                    TextStyle(
                      fontSize: 18.r,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ).sourceSansProSemiBold,
              ),
            ),
            if (option.trailingIcon != null)
              Icon(option.trailingIcon, size: 24.r, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300], thickness: 1);
  }
}
