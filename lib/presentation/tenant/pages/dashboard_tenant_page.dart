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

  // final StatefulNavigationShell shell;

  const DashboardTenantPage({super.key});

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
          child: Column(
            children: [
              AppHeaderLayout(content: _buildHeader()),
              ScrollableBodyWidget(bodyContent: _buildContent()),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomFloatingAction(
          isSelected: _selected,
          onNavigate: (String route) {
            switch (route) {
              case 'documents':
                context.pushNamed(DocumentsTenantPage.routeName);
                break;
              case 'payments':
                context.pushNamed(HomeTenantPage.routeName);
                break;
              case 'inspection':
                context.pushNamed(PropertyInspectionPage.routeName);
                break;
            }
          },
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
                  _scaffoldKey.currentState?.openDrawer();
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

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBillingPaymentsCard(),
        CustomSpacer(),
        _buildDatePaymentsCard(),
        CustomSpacer(),
        _buildPropertyInfoCard(),
        CustomSpacer(),
        _buildPAgencyInfoCard(),
      ],
    );
  }

  Widget _buildPropertyInfoCard() {
    return PropertyCard(
      property: PropertyModel(
        title: 'Maison à abobo',
        imageUrl: 'assets/images/temps.png',
        amenities: List.generate(
          8,
          (index) =>
              AmenityModel(text: '2 douches', iconData: 'shower_outlined'),
        ),
      ),
      showMoreInfo: false,
      onPressed: () {
        context.pushNamed(
          PortalDetailPage.routeName,
          pathParameters: {'id': '1', 'type': 'tenant'},
        );
      },
    );
  }

  Widget _buildPAgencyInfoCard() {
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

  Widget _buildBillingPaymentsCard() {
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

  Widget _buildDatePaymentsCard() {
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

  _selected(int i) {
    return true;
  }
}
