import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../portal/pages/portal_detail_page.dart';
import 'profile_tenant_page.dart';

class DashboardContentPage extends StatelessWidget {
  static const routeName = 'dashboardContent';
  static const routePath = '/dashboard';

  const DashboardContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the nearest Scaffold to open the drawer
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Column(
      children: [
        AppHeaderLayout(content: _buildHeader(context)),
        ScrollableBodyWidget(bodyContent: _buildContent(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
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
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularIcon(
                iconAsset: Assets.menu,
                iconSize: 16.sp,
                onPressed: () {
                  // Obtenir le scaffold parent du DashboardTenantPage
                  Scaffold.of(context).openDrawer();
                },
              ),
              Text(
                'Accueil',
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
                  context.pushNamed(ProfileTenantPage.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBillingPaymentsCard(context),
        CustomSpacer(),
        _buildDatePaymentsCard(context),
        CustomSpacer(),
        _buildPropertyInfoCard(context),
        CustomSpacer(),
        _buildPAgencyInfoCard(context),
      ],
    );
  }

  Widget _buildPropertyInfoCard(BuildContext context) {
    return PropertyCard(
      property: EstateModel(),
      showMoreInfo: false,
      onPressed: () {
        context.pushNamed(
          PortalDetailPage.routeName,
          pathParameters: {'id': '1', 'type': 'tenant'},
        );
      },
    );
  }

  Widget _buildPAgencyInfoCard(BuildContext context) {
    return InfoCardWidget(
      title: 'Informations sur l\'agence',
      child: Column(
        children: [
          InfoRowWidget(
            icon: Icons.phone,
            text: 'Contact : +225 06 75 76 56 57',
          ),
          SizedBox(height: 16.sp),
          InfoRowWidget(
            icon: Icons.location_on_outlined,
            text: 'Localisation : Cote d\'ivoire, Abidjan, zone 4',
          ),
        ],
      ),
    );
  }

  Widget _buildBillingPaymentsCard(BuildContext context) {
    return StatsCardWidget(
      title: 'Loyer mensuel',
      value: '200 000 FCFA',
      iconData: Icons.credit_card_outlined,
      iconBackgroundColor: AppColors.redColor,
      arrowColor: AppColors.redColor,
      valueColor: AppColors.redColor,
      onTap: () {},
    );
  }

  Widget _buildDatePaymentsCard(BuildContext context) {
    return StatsCardWidget(
      title: 'Date limite de paiement',
      value: DateTime.now().add(Duration(days: 5)).humanWithoutTime(),
      iconData: Icons.calendar_month_outlined,
      iconBackgroundColor: AppColors.primary,
      arrowColor: AppColors.primary,
      valueColor: AppColors.primary,
      onTap: () {},
    );
  }
}
