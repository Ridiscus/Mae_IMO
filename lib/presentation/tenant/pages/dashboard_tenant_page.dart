import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/tenant/pages/home_tenant_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/profile_tenant_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/property_inspection_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../shared/models/index.dart';
import '../../portal/pages/portal_detail_page.dart';
import 'document_tenant_page.dart';

class DashboardTenantPage extends StatefulWidget {
  static const routeName = 'dashboardTenant';
  static const routePath = '/dashboard-tenant';

  final StatefulNavigationShell navigationShell;

  const DashboardTenantPage({
    super.key, 
    required this.navigationShell
  });

  @override
  State<DashboardTenantPage> createState() => _DashboardTenantPageState();
}

class _DashboardTenantPageState extends State<DashboardTenantPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          name: 'Nom de l\'utilisateur',
          email: 'utilsateur@gmail.com',
          profileType: "tenant",
          // onDocumentsTap: () {},
          onHomeTap: () {
            _scaffoldKey.currentState?.closeDrawer();
          },

          // onPaymentsTap: () {},
          onProfileTap: () {
            context.pushNamed(ProfileTenantPage.routeName);
          },
          onCloseTap: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
          // onCurrentSituationTap: () {},
        ),
        body: SafeArea(
          top: false,
          child: widget.navigationShell,
        ),

        bottomNavigationBar: CustomFloatingAction(
          selectedIndex: widget.navigationShell.currentIndex,
          onNavigate: (int index) {
            widget.navigationShell.goBranch(
              index,
              // Ne pas animer à nouveau si on est déjà à cet index
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}
