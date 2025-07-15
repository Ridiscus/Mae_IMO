import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/context_extension.dart';
import 'package:maelys_imo/core/extensions/text_style_ext.dart';

class CustomDrawer extends StatelessWidget {
  final String name;
  final String email;
  final String? profileImage;
  final Function()? onHomeTap;
  final Function()? onWalletTap;
  final Function()? onTransactionsTap;
  final Function()? onProfileTap;
  final Function()? onSettingsTap;
  final Function()? onLogoutTap;
  final Function()? onCloseTap;
  final int selectedIndex;

  const CustomDrawer({
    Key? key,
    required this.name,
    required this.email,
    this.profileImage,
    this.onHomeTap,
    this.onWalletTap,
    this.onTransactionsTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogoutTap,
    this.onCloseTap,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: context.getSize.width / 1.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileSection(),
            SizedBox(height: 32.sp),
            _buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.only(top: 24.sp, left: 24.sp, right: 24.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange,
                    width: 2.r,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                      profileImage != null
                          ? DecorationImage(
                        image: NetworkImage(profileImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child:
                    profileImage == null
                        ? CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        size: 36.sp,
                        color: Colors.white,
                      ),
                    )
                        : null,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  onPressed: onCloseTap ?? () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style:
                  TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ).sourceSansProSemiBold,
            ),
          ),
          SizedBox(height: 8.sp),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              email,
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      _MenuItem(
        icon: Icons.home_outlined,
        title: 'Home',
        onTap: onHomeTap,
        isSelected: selectedIndex == 0,
      ),
      _MenuItem(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Wallet',
        onTap: onWalletTap,
        isSelected: selectedIndex == 1,
      ),
      _MenuItem(
        icon: Icons.swap_horiz_outlined,
        title: 'Transactions',
        onTap: onTransactionsTap,
        isSelected: selectedIndex == 2,
      ),
      _MenuItem(
        icon: Icons.person_outline,
        title: 'Profile',
        onTap: onProfileTap,
        isSelected: selectedIndex == 3,
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        title: 'Setting',
        onTap: onSettingsTap,
        isSelected: selectedIndex == 4,
      ),
      _MenuItem(
        icon: Icons.power_settings_new_outlined,
        title: 'Logout',
        onTap: onLogoutTap,
        isSelected: selectedIndex == 5,
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.sp),
      itemBuilder: (context, index) => menuItems[index],
    );
  }

  Widget _buildBottomIndicator() {
    return Container(
      width: 48.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;
  final bool isSelected;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.black : Colors.black54,
        size: 24.sp,
      ),
      title: Text(
        title,
        style:
            TextStyle(
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.black87,
            ).sourceSansProRegular,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.sp),
      minLeadingWidth: 24.w,
      dense: true,
      visualDensity: VisualDensity.comfortable,
    );
  }
}
