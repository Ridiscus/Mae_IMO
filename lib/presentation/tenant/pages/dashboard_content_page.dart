import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/manager/state/dashboard/dashboard_bloc.dart';
import '../../portal/pages/portal_detail_page.dart';
import 'profile_tenant_page.dart';

class DashboardContentPage extends StatelessWidget {
  static const routeName = 'dashboardContent';
  static const routePath = '/dashboard';

  const DashboardContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppHeaderLayout(content: _buildHeader(context)),
        ScrollableBodyWidget(
          bodyContent: _buildContent(context),
          onRefresh: () async {
            context.read<DashboardBloc>().add(FetchTenantDashboardEvent());
          },
        ),
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
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final dashboardModel = state.tenantDashboardModel;
    final isLoading = (state.isLoading ?? true) || dashboardModel == null;

    return Skeletonizer(
      enabled: isLoading,
      child: PropertyCard(
        property: dashboardModel?.locataire!.estate! ?? EstateModel(),
        showMoreInfo: false,
        onPressed: () {
          context.pushNamed(
            PortalDetailPage.routeName,
            pathParameters: {
              'id': '${dashboardModel!.locataire!.bienId}',
              'type': 'tenant',
            },
          );
        },
      ),
    );
  }

  Widget _buildPAgencyInfoCard(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final agencyModel = state.tenantDashboardModel?.locataire!.agency;
    final isLoading = (state.isLoading ?? true) || agencyModel == null;

    return Skeletonizer(
      enabled: isLoading,
      child: InfoCardWidget(
        title: 'Informations sur l\'agence',
        child: Column(
          children: [
            InfoRowWidget(
              icon: Icons.phone,
              text: 'Contact : ${agencyModel?.contact ?? ''}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.location_on_outlined,
              text: 'Localisation : ${agencyModel?.adresse ?? ''}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingPaymentsCard(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final estateModel = state.tenantDashboardModel?.locataire!.estate;
    final isLoading = (state.isLoading ?? true) || estateModel == null;

    return Skeletonizer(
      enabled: isLoading,
      child: StatsCardWidget(
        title: 'Loyer mensuel',
        value: "${estateModel?.prix}".formatCurrency(),
        iconData: Icons.credit_card_outlined,
        iconBackgroundColor: AppColors.redColor,
        arrowColor: AppColors.redColor,
        valueColor: AppColors.redColor,
        onTap: () {},
      ),
    );
  }

  Widget _buildDatePaymentsCard(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final estateModel = state.tenantDashboardModel?.locataire!.estate;
    final isLoading = (state.isLoading ?? true) || estateModel == null;
    return Skeletonizer(
      enabled: isLoading,
      child: StatsCardWidget(
        title: 'Date limite de paiement',
        value:
            DateTime.now()
                .copyWith(day: int.tryParse(estateModel?.dateFixe ?? ""))
                .humanWithoutTime(),
        iconData: Icons.calendar_month_outlined,
        iconBackgroundColor: AppColors.primary,
        arrowColor: AppColors.primary,
        valueColor: AppColors.primary,
        onTap: () {},
      ),
    );
  }
}
