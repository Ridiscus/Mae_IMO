import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'agency_detail_page.dart';
import 'create_agency_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';

class AgenciesListPage extends StatefulWidget {
  static const routeName = 'agenciesList';
  static const routePath = '/commercial/agencies';

  const AgenciesListPage({super.key});

  @override
  State<AgenciesListPage> createState() => _AgenciesListPageState();
}

class _AgenciesListPageState extends State<AgenciesListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(FetchCommercialAgencesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerHeight: MediaQuery.of(context).size.height * .20,
      headerContent: Row(
        children: [
          const CircularBackButton(),
          SizedBox(width: 12.w),
          Text(
            'Agences Partenaires',
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
          const Spacer(),
          _buildAddButton(),
        ],
      ),
      onRefresh: () async {
        context.read<DashboardBloc>().add(FetchCommercialAgencesEvent());
      },
      bodyContent: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final agencies = state.agencies ?? [];

          if (state.isLoading == true && agencies.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (agencies.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 64.sp,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Aucune agence trouvée',
                      style:
                          TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ).sourceSansProRegular,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children:
                agencies
                    .map(
                      (agency) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildAgencyCard(agency),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }

  Widget _buildAgencyCard(AgencyModel agency) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap:
            () => context.pushNamed(AgencyDetailPage.routeName, extra: agency),
        contentPadding: EdgeInsets.all(12.sp),
        leading: Container(
          width: 50.sp,
          height: 50.sp,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              (agency.name != null && agency.name!.isNotEmpty)
                  ? agency.name!.substring(0, 1).toUpperCase()
                  : 'A',
              style:
                  TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ).sourceSansProBold,
            ),
          ),
        ),
        title: Text(
          agency.name ?? 'Nom inconnu',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ).sourceSansProBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              'ID: ${agency.codeId ?? '---'} • ${agency.commune ?? '---'}',
              style:
                  TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
          ],
        ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => context.pushNamed(CreateAgencyPage.routeName),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20.sp),
            SizedBox(width: 4.w),
            Text(
              'NOUVELLE',
              style:
                  TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ).sourceSansProBold,
            ),
          ],
        ),
      ),
    );
  }
}
