import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_list_page.dart';
import 'package:maelys_imo/presentation/agent/pages/profile_agent_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/profile_tenant_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class HomeAgentPage extends StatefulWidget {
  static const routeName = 'homeAgent';
  static const routePath = '/home-agent';

  const HomeAgentPage({super.key});

  @override
  State<HomeAgentPage> createState() => _HomeAgentPageState();
}

class _HomeAgentPageState extends State<HomeAgentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        name: 'Nom de l\'utilisateur',
        email: 'utilsateur@gmail.com',
        onHomeTap: () {
          _scaffoldKey.currentState?.closeDrawer();
          // Already on home page
        },
        onProfileTap: () {
          _scaffoldKey.currentState?.closeDrawer();
          context.pushNamed(ProfileAgentPage.routeName);
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
            top: MediaQuery.of(context).size.height * .22,

            child: _buildContent(),
          ),

          Positioned(
            left: 16.sp,
            right: 16.sp,
            top: MediaQuery.of(context).size.height * .14,
            child: _buildTotalRentCard(),
          ),
        ],
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
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primary,
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
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTenantsUpToDateCard(),
              CustomSpacer(),
              _buildTenantsInArrearsCard(),
              CustomSpacer(),
              _buildPendingPaymentsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.sp),
      constraints: BoxConstraints(maxHeight: 160.h),
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
        children: [
          Text(
            'Montant total des loyers réçu',
            style:
                TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                ).sourceSansProRegular,
          ),
          CustomSpacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '500 000',
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
    );
  }

  Widget _buildTenantsUpToDateCard() {
    return _buildStatCard(
      title: 'Nombre de locataire à jours',
      value: '20',
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
    return _buildStatCard(
      title: 'Nombre de locataire en retard',
      value: '20',
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
    return _buildStatCard(
      title: 'Nombre de paiement en attente',
      value: '20',
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData iconData,
    required Color iconBackgroundColor,
    required Color arrowColor,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 120.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: arrowColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              decoration: BoxDecoration(
                color: arrowColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
              child: Center(
                child: Icon(iconData, color: arrowColor, size: 30.sp),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.black,
                          ).sourceSansProSemiBold,
                    ),

                    Text(
                      value,
                      style:
                          TextStyle(
                            fontSize: 38.sp,
                            fontWeight: FontWeight.bold,
                            color: valueColor,
                          ).sourceSansProBold,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
