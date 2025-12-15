import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/profile_agent_page.dart';
import 'package:maelys_imo/presentation/agent/pages/property_inspection_list_page.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_list_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/domain/models/index.dart';
import '../../../core/manager/state/dashboard/dashboard_bloc.dart';

class HomeAgentPage extends StatefulWidget {
  static const routeName = 'homeAgent';
  static const routePath = '/home-agent';

  const HomeAgentPage({super.key});

  @override
  State<HomeAgentPage> createState() => _HomeAgentPageState();
}

class _HomeAgentPageState extends State<HomeAgentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late DashboardState _dashboardState;
  AgentDashboardModel? _agentDashboardModel;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _dashboardState = context.select((DashboardBloc bloc) => bloc.state);
    _agentDashboardModel = _dashboardState.agentDashboardModel;
    _isLoading = _dashboardState.isLoading ?? false;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          // name: 'Nom de l\'utilisateur',
          // email: 'utilsateur@gmail.com',
          onHomeTap: () {
            _scaffoldKey.currentState?.closeDrawer();
            // Already on home page
          },
          onProfileTap: () {
            context.pushNamed(ProfileAgentPage.routeName);
          },
          onCurrentSituationTap: () {
            context.pushNamed(PropertyInspectionListPage.routeName);
          },
          onCloseTap: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
          selectedIndex: 0, // Home is selected
        ),
        body: Stack(
          children: [
            Positioned(child: _buildHeader()),

            Positioned.fill(
              top: (MediaQuery.of(context).size.height * .22).sp,
              child: _buildContent(),
            ),

            Positioned(
              left: 16.sp,
              right: 16.sp,
              top: (MediaQuery.of(context).size.height * .14).sp,
              child: _buildTotalRentCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Stack(
        children: [
          // Ajout des illustrations décoratives
          IllustrationHeader(
            color: Colors.white,
            primaryAlpha: 0.07,
            secondaryAlpha: 0.03,
          ),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularIcon(
                    iconAsset: Assets.menu,
                    iconSize: 16.sp,
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Text(
                    'Statistiques',
                    style:
                        TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ).sourceSansProBold,
                  ),
                  CircularIcon(
                    iconAsset: Assets.user,

                    onPressed: () {
                      context.pushNamed(ProfileAgentPage.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Skeletonizer(
      enabled: _isLoading,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: (150 / 1.8).h),
        decoration: BoxDecoration(
          color: AppColors.scaffold,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            context.read<DashboardBloc>().add(FetchAgentDashboardEvent());
          },
          child: ListView(
            padding: EdgeInsets.all(16.sp),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTenantsUpToDateCard(),
                  CustomSpacer(),
                  _buildTenantsInArrearsCard(),
                  CustomSpacer(),
                  _buildPendingPaymentsCard(),
                  CustomSpacer(),
                  _buildPropertyInspectionCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRentCard() {
    return Skeletonizer(
      enabled: _isLoading,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.sp),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.scaffold.withValues(alpha: .12),
            width: 1.sp,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Montant total des loyers réçu',
              style:
                  TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ).sourceSansProRegular,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${_agentDashboardModel?.totalLoyersPercus ?? 0}'
                      .formatCurrency(symbol: ""),
                  style:
                      TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ).sourceSansProBold,
                ),
                SizedBox(width: 8.sp),
                Text(
                  'FCFA',
                  style:
                      TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ).sourceSansProRegular,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantsUpToDateCard() {
    return StatsCardWidget(
      title: 'Nombre de locataire à jours',
      value: '${_agentDashboardModel?.locatairesAJour ?? 0}',
      iconData: Icons.calendar_today,
      iconBackgroundColor: AppColors.primary,
      arrowColor: AppColors.success,
      valueColor: AppColors.success,
      onTap: () {
        // Navigate to tenants up to date list
        context.pushNamed(
          TenantListPage.routeName,
          pathParameters: {'type': 'up-to-date'},
        );
      },
    );
  }

  Widget _buildTenantsInArrearsCard() {
    return StatsCardWidget(
      title: 'Nombre de locataire en retard',
      value: '${_agentDashboardModel?.locatairesEnRetard ?? 0}',
      iconData: Icons.warning_amber_rounded,
      iconBackgroundColor: AppColors.primary,
      arrowColor: AppColors.redColor,
      valueColor: AppColors.redColor,
      onTap: () {
        // Navigate to tenants in arrears list
        context.pushNamed(
          TenantListPage.routeName,
          pathParameters: {'type': 'late'},
        );
      },
    );
  }

  Widget _buildPendingPaymentsCard() {
    return StatsCardWidget(
      title: 'Nombre de paiement en attente',
      value: '${_agentDashboardModel?.paiementsEnAttente ?? 0}',
      iconData: Icons.watch_later_outlined,
      iconBackgroundColor: AppColors.primary,
      arrowColor: AppColors.orange,
      valueColor: AppColors.orange,
      onTap: () {
        // Navigate to pending payments list
        context.pushNamed(
          TenantListPage.routeName,
          pathParameters: {'type': 'pending'},
        );
      },
    );
  }

  // État des lieux card
  Widget _buildPropertyInspectionCard() {
    return StatsCardWidget(
      title: 'États des lieux à effectuer',
      value: '${_agentDashboardModel?.etatsLieuEnAttente ?? 0}',
      iconData: Icons.home_work_outlined,
      iconBackgroundColor: AppColors.primary,
      arrowColor: AppColors.primary,
      valueColor: AppColors.primary,
      onTap: () {
        context.pushNamed(PropertyInspectionListPage.routeName);
      },
    );
  }
}
