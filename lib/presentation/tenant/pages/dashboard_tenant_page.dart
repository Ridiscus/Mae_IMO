import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/presentation/tenant/pages/profile_tenant_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/manager/state/dashboard/dashboard_bloc.dart';
import '../../../core/utils/index.dart';

class DashboardTenantPage extends StatefulWidget {
  static const routeName = 'dashboardTenant';
  static const routePath = '/dashboard-tenant';

  final StatefulNavigationShell navigationShell;

  const DashboardTenantPage({super.key, required this.navigationShell});

  @override
  State<DashboardTenantPage> createState() => _DashboardTenantPageState();
}

class _DashboardTenantPageState extends State<DashboardTenantPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final userModel = context.select((AuthBloc bloc) => bloc.state.userModel);
    final dashboardModel = state.tenantDashboardModel?.locataire;


    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          name: dashboardModel?.fullName ?? '',
          email: dashboardModel?.email ?? '',
          profileImage: CoreHelper.fullLink(userModel?.profileImage ?? ""),
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
        body: SafeArea(top: false, child: widget.navigationShell),

        bottomNavigationBar: CustomNavigationBar(
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
