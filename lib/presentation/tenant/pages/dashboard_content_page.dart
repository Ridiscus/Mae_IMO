import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
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
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ScrollableBodyWidget(
              bodyContent: _buildContent(context),
              onRefresh: () async {
                context.read<DashboardBloc>().add(FetchTenantDashboardEvent());
              },
            ),
          ),
        ],
      ),
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
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularIcon(
                iconAsset: Assets.menu,
                iconSize: 16.sp,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Text(
                'Accueil',
                style: TextStyle(
                  fontSize: 24.sp,
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
    final state = context.select((DashboardBloc bloc) => bloc.state);
    if ((state.isLoading ?? false) && state.tenantDashboardModel == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
    final estate = dashboardModel?.locataire?.estate;

    if (estate == null) return const SizedBox.shrink();

    return PropertyCard(
      property: estate,
      showMoreInfo: false,
      onPressed: () {
        context.pushNamed(
          PortalDetailPage.routeName,
          pathParameters: {
            'id': '${dashboardModel?.locataire?.bienId ?? 0}',
            'type': 'tenant',
          },
        );
      },
    );
  }

  Widget _buildPAgencyInfoCard(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final agencyModel = state.tenantDashboardModel?.locataire?.agency;

    if (agencyModel == null) return const SizedBox.shrink();

    return InfoCardWidget(
      title: 'Informations sur l\'agence',
      child: Column(
        children: [
          InfoRowWidget(
            icon: Icons.phone,
            text: 'Contact : ${agencyModel.contact ?? ''}',
          ),
          SizedBox(height: 16.sp),
          InfoRowWidget(
            icon: Icons.location_on_outlined,
            text: 'Localisation : ${agencyModel.adresse ?? ''}',
          ),
        ],
      ),
    );
  }

  Widget _buildBillingPaymentsCard(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final estateModel = state.tenantDashboardModel?.locataire?.estate;

    if (estateModel == null) return const SizedBox.shrink();

    return StatsCardWidget(
      title: 'Loyer mensuel',
      value: "${estateModel.prix}".formatCurrency(),
      iconData: Icons.credit_card_outlined,
      iconBackgroundColor: AppColors.redColor,
      arrowColor: AppColors.redColor,
      valueColor: AppColors.redColor,
      onTap: () {},
    );
  }

  Widget _buildDatePaymentsCard(BuildContext context) {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final estateModel = state.tenantDashboardModel?.locataire?.estate;

    if (estateModel == null) return const SizedBox.shrink();
    
    final int day = int.tryParse(estateModel.dateFixe ?? "") ?? 5;

    return StatsCardWidget(
      title: 'Date limite de paiement',
      value: DateTime.now().copyWith(day: day).humanWithoutTime(),
      iconData: Icons.calendar_month_outlined,
      iconBackgroundColor: AppColors.primary,
      arrowColor: AppColors.primary,
      valueColor: AppColors.primary,
      onTap: () {},
    );
  }
}
