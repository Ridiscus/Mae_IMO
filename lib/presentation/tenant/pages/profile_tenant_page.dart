import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_detail_page.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/update_email_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/update_password_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/domain/models/index.dart';

class ProfileTenantPage extends StatefulWidget {
  static const routeName = 'profileTenant';
  static const routePath = '/profile-tenant';

  const ProfileTenantPage({super.key});

  @override
  State<ProfileTenantPage> createState() => _ProfileTenantPageState();
}

class _ProfileTenantPageState extends State<ProfileTenantPage> {
  late UserModel? _userModel;

  @override
  Widget build(BuildContext context) {
    _userModel = context.select((AuthBloc bloc) => bloc.state).userModel;

    // Define contact info
    final List<ProfileContactInfo> contactInfo = [
      ProfileContactInfo(
        icon: Icons.email_outlined,
        text: _userModel?.email ?? '',
      ),
      ProfileContactInfo(
        icon: Icons.phone_outlined,
        text: _userModel?.contact ?? '',
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
            pathParameters: {
              'id': '${_userModel?.asTenant()?.bienId}',
              'type': 'tenant',
            },
          );
        },
      ),
      // ProfileEditOption(
      //   icon: Icons.adaptive.flip_camera,
      //   title: 'Modifier ma photo',
      //   onTap: () {
      //     // Handle photo edit
      //   },
      // ),
      ProfileEditOption(
        icon: Icons.alternate_email,
        title: 'Modifier mon email',
        onTap: () {
          context.pushNamed(UpdateEmailPage.routeName);
        },
      ),
      ProfileEditOption(
        icon: Icons.lock_outline,
        title: 'Modifier mon mot de passe',
        onTap: () {
          context.pushNamed(UpdatePasswordPage.routeName);
        },
      ),

      // ProfileEditOption(
      //   icon: Icons.phone,
      //   title: 'Contacter l\'agence',
      //   onTap: () {
      //     context.pushNamed(ContactAgencyPage.routeName);
      //   },
      // ),
      ProfileEditOption(
        icon: Icons.logout_outlined,
        title: 'Déconnexion',
        onTap: () {
          context.read<AuthBloc>().add(LogoutEvent());
          context.goNamed(PortalPage.routeName);
        },
      ),
    ];

    return ProfilePageLayout(
      userName: _userModel?.fullName ?? '',
      userId: _userModel?.codeId ?? '',
      contactInfo: contactInfo,
      editOptions: editOptions,
      profileBackgroundColor: AppColors.primary,

      onLogoutPressed: () {
        // context.goNamed(PortalPage.routeName);
      },
    );
  }
}
