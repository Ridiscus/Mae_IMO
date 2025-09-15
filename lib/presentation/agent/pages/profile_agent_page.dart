import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/domain/models/index.dart';

class ProfileAgentPage extends StatefulWidget {
  static const routeName = 'profileAgent';
  static const routePath = '/profile-agent';

  const ProfileAgentPage({super.key});

  @override
  State<ProfileAgentPage> createState() => _ProfileAgentPageState();
}

class _ProfileAgentPageState extends State<ProfileAgentPage> {

  late UserModel? _userModel;

  @override
  Widget build(BuildContext context) {
    // _userModel = context.select((AuthBloc bloc) => bloc.state).userModel;

    // // Define contact info
    // final List<ProfileContactInfo> contactInfo = [
    //   ProfileContactInfo(
    //     icon: Icons.email_outlined,
    //     text: _userModel?.email ?? '',
    //   ),
    //   ProfileContactInfo(
    //     icon: Icons.phone_outlined,
    //     text: _userModel?.contact ?? '',
    //   ),
    // ];

    // Define edit options for agent
    final List<ProfileEditOption> editOptions = [
      ProfileEditOption(
        icon: Icons.adaptive.flip_camera_rounded,
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
        icon: Icons.logout_outlined,
        title: 'Déconnexion',
        onTap: () {
          context.goNamed(PortalPage.routeName);
        },
      ),
    ];

    return ProfilePageLayout(
      // userName: _userModel?.fullName ?? '',
      // userId: _userModel?.codeId ?? '',
      // contactInfo: contactInfo,
      editOptions: editOptions,
      profileBackgroundColor: AppColors.primary,
      onLogoutPressed: () {
        context.goNamed(PortalPage.routeName);
      },
    );
  }


}
