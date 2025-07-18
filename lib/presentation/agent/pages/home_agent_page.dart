import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_list_page.dart';
import 'package:maelys_imo/presentation/agent/pages/profile_agent_page.dart';
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
          context.goNamed(ProfileAgentPage.routeName);
        },
        onCloseTap: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
        selectedIndex: 0, // Home is selected
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.sp,
        left: 16.sp,
        right: 16.sp,
        bottom: 16.sp,
      ),
      width: double.infinity,
      color: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          Text(
            'Statistiques',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
          ),
          InkWell(
            onTap: () {
              // Navigate to agent profile page
              context.goNamed(ProfileAgentPage.routeName);
            },
            child: CircleAvatar(
              radius: 16.r,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      color: Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalRentCard(),
              SizedBox(height: 24.sp),
              _buildTenantsUpToDateCard(),
              SizedBox(height: 16.sp),
              _buildTenantsInArrearsCard(),
              SizedBox(height: 16.sp),
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
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Montant total des loyers réçu',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
            ).sourceSansProRegular,
          ),
          SizedBox(height: 16.sp),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '500 000',
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
              ),
              SizedBox(width: 8.sp),
              Text(
                'FCFA',
                style: TextStyle(
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
      arrowColor: Colors.green,
      valueColor: Colors.green,
      onTap: () {
        // Navigate to tenants up to date list
        context.goNamed(
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
      arrowColor: Colors.red,
      valueColor: Colors.red,
      onTap: () {
        // Navigate to tenants in arrears list
        context.goNamed(
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
      arrowColor: Colors.orange,
      valueColor: Colors.orange,
      onTap: () {
        // Navigate to pending payments list
        context.goNamed(
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
          SizedBox(width: 16.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ).sourceSansProRegular,
                ),
                SizedBox(height: 4.sp),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ).sourceSansProBold,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: arrowColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
