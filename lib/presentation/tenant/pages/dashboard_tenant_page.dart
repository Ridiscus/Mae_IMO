import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_list_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/home_tenant_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/profile_tenant_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/property_inspection_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import 'document_tenant_page.dart';

class DashboardTenantPage extends StatefulWidget {
  static const routeName = 'dashboardTenant';
  static const routePath = '/dashboard-tenant';

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
          onDocumentsTap: () {
            context.pushNamed(DocumentsTenantPage.routeName);
          },
          onHomeTap: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
          onPaymentsTap: () {
            context.pushNamed(HomeTenantPage.routeName);
          },

          onProfileTap: () {
            context.pushNamed(ProfileTenantPage.routeName);
          },
          onCloseTap: () {
            _scaffoldKey.currentState?.closeDrawer();
          },
          onCurrentSituationTap: () {
            context.pushNamed(PropertyInspectionPage.routeName);
          },
        ),
        body: Stack(
          children: [
            Positioned(child: _buildHeader()),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * .16,
              child: _buildContent(),
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
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
              _buildBilingPaymentsCard(),
              CustomSpacer(),

              _buildPropertyInfoCard(),
              CustomSpacer(),
              _buildPAgencyInfoCard(),
              CustomSpacer(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyInfoCard() {
    return InfoCardWidget(
      title: 'Mon Bien loué',
      child: Column(
        children: [
          InfoRowWidget(icon: Icons.home_outlined, text: 'Type : villa'),
          CustomSpacer(),
          InfoRowWidget(
            icon: Icons.location_on_outlined,
            text: 'Localisation : Marcory',
          ),
          CustomSpacer(),
          InfoRowWidget(
            icon: Icons.money_outlined,
            text: 'loyer : 200 000 FCFA',
          ),
          CustomSpacer(),
          InfoRowWidget(icon:  Icons.meeting_room_outlined, text: 'Chambres: 4'),
          CustomSpacer(),
          InfoRowWidget(icon:  Icons.bathroom_outlined, text:  'Salles de bain: 3'),

        ],
      ),
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


  Widget _buildBilingPaymentsCard() {
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
}
