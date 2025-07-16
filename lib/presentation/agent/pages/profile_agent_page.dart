import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/extensions/index.dart';

class ProfileAgentPage extends StatefulWidget {
  static const routeName = 'profileAgent';
  static const routePath = '/agent-profile';

  const ProfileAgentPage({super.key});

  @override
  State<ProfileAgentPage> createState() => _ProfileAgentPageState();
}

class _ProfileAgentPageState extends State<ProfileAgentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: _buildProfileContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.sp,
        left: 16.sp,
        right: 16.sp,
        bottom: 0.sp,
      ),
      width: double.infinity,
      color: Color(0xFF0A2342),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 30.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      width: double.infinity,
      color: Color(0xFF0A2342),
      child: Column(
        children: [
          _buildProfileInfo(),
          _buildEditOptions(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.sp, horizontal: 16.sp),
      decoration: BoxDecoration(
        color: Color(0xFF0A2342),
      ),
      child: Column(
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange,
                width: 2.sp,
              ),
            ),
            child: Center(
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 60.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.sp),
          Text(
            'Nom de l\'agent',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
          ),
          SizedBox(height: 4.sp),
          Text(
            'ID : 132Mo7E',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[300],
            ).sourceSansProRegular,
          ),
          SizedBox(height: 24.sp),
          _buildContactInfo(
            icon: Icons.email_outlined,
            text: 'agent@gmail.com',
          ),
          SizedBox(height: 16.sp),
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
        Icon(
          icon,
          size: 24.sp,
          color: Colors.grey[300],
        ),
        SizedBox(width: 16.sp),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildEditOptions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
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
        padding: EdgeInsets.symmetric(vertical: 16.sp),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: Colors.black87,
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ).sourceSansProSemiBold,
              ),
            ),
            Icon(
              Icons.edit,
              size: 24.sp,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
    );
  }
}
