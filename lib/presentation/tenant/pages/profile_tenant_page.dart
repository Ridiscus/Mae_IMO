import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_detail_page.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/contact_agency_page.dart';
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
    // Define contact info
    final List<ProfileContactInfo> contactInfo = [
      ProfileContactInfo(
        icon: Icons.email_outlined,
        text: 'user@gmail.com',
      ),
      ProfileContactInfo(
        icon: Icons.phone_outlined,
        text: '+225 0578687749',
      ),
    ];

    // Define edit options with tenant-specific options
    final List<ProfileEditOption> editOptions = [
      ProfileEditOption(
        icon: Icons.remove_red_eye_outlined,
        title: 'Mon bien loué',
        onTap: () {
          context.pushNamed(
            PortalDetailPage.routeName,
            pathParameters: {'id': '1', 'type': 'tenant'},
          );
        },
      ),
      ProfileEditOption(
        icon: Icons.adaptive.flip_camera,
        title: 'Modifier ma photo',
        onTap: () {
          // Handle photo edit
        },
      ),
      ProfileEditOption(
        icon: Icons.alternate_email,
        title: 'Modifier mon email',
        onTap: () {
          // Handle email edit
        },
      ),
      ProfileEditOption(
        icon: Icons.lock_outline,
        title: 'Modifier mon mot de passe',
        onTap: () {
          // Handle password edit
        },
      ),
      ProfileEditOption(
        icon: Icons.phone,
        title: 'Contacter l\'agence',
        onTap: () {
          context.pushNamed(ContactAgencyPage.routeName);
        },
      ),
    ];

    return ProfilePageLayout(
      userName: 'Nom du locataire',
      userId: '132Mo7E',
      contactInfo: contactInfo,
      editOptions: editOptions,
      profileBackgroundColor: AppColors.primary,
      onLogoutPressed: () {
        context.goNamed(PortalPage.routeName);
      },
    );
  }


}
