import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class ProfileTenantPage extends StatefulWidget {
  static const routeName = 'profileTenant';
  static const routePath = '/profile-tenant';

  const ProfileTenantPage({super.key});

  @override
  State<ProfileTenantPage> createState() => _ProfileTenantPageState();
}

class _ProfileTenantPageState extends State<ProfileTenantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: SingleChildScrollView(child: _buildProfileContent())),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 16.r, right: 16.r),
      width: double.infinity,
      color: AppColors.primary,
      alignment: Alignment.centerLeft,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularBackButton(),

            CircularIcon(
              iconAsset: Assets.logout,
              onPressed: () {
                context.goNamed(PortalPage.routeName);
              },
            ),
          ],

        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: Column(children: [_buildProfileInfo(), _buildEditOptions()]),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.r),

      decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        children: [
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 2.r),
            ),
            child: Center(
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 60.r, color: Colors.black54),
              ),
            ),
          ),
          SizedBox(height: 16.r),
          Text(
            'Nom de l\'agent',
            style:
                TextStyle(
                  fontSize: 24.r,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
          SizedBox(height: 4.r),
          Text(
            'ID : 132Mo7E',
            style:
                TextStyle(
                  fontSize: 16.r,
                  color: Colors.grey[300],
                ).sourceSansProRegular,
          ),
          SizedBox(height: 24.r),
          _buildContactInfo(
            icon: Icons.email_outlined,
            text: 'agent@gmail.com',
          ),
          SizedBox(height: 16.r),
          _buildContactInfo(
            icon: Icons.phone_outlined,
            text: '+225 0578687749',
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24.r, color: Colors.grey[300]),
        SizedBox(width: 16.r),
        Text(
          text,
          style:
              TextStyle(
                fontSize: 16.r,
                color: Colors.white,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildEditOptions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          _buildEditOption(
            icon: Icons.camera_alt_outlined,
            title: 'Modifier ma photo',
            onTap: () {
              // Handle photo edit
            },
          ),
          _buildDivider(),
          _buildEditOption(
            icon: Icons.email_outlined,
            title: 'Modifier mon email',
            onTap: () {
              // Handle email edit
            },
          ),
          _buildDivider(),
          _buildEditOption(
            icon: Icons.lock_outline,
            title: 'Modifier mon mot de passe',
            onTap: () {
              // Handle password edit
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildEditOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.r),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: Colors.black87),
            SizedBox(width: 16.r),
            Expanded(
              child: Text(
                title,
                style:
                    TextStyle(
                      fontSize: 18.r,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ).sourceSansProSemiBold,
              ),
            ),
            Icon(Icons.edit, size: 24.r, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300], thickness: 1);
  }
}
