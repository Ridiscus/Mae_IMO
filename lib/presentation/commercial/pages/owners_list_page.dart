import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'create_owner_page.dart';
import 'owner_detail_page.dart';

class OwnersListPage extends StatefulWidget {
  static const routeName = 'ownersList';
  static const routePath = '/commercial/owners';

  const OwnersListPage({super.key});

  @override
  State<OwnersListPage> createState() => _OwnersListPageState();
}

class _OwnersListPageState extends State<OwnersListPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchCommercialOwnersEvent());
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
            'Propriétaires',
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
      bodyContent: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.isLoading ?? false) {
            return const Center(child: CircularProgressIndicator());
          }

          final owners = state.owners ?? [];

          if (owners.isEmpty) {
            return const Center(child: Text('Aucun propriétaire trouvé'));
          }

          return Column(
            children:
                owners
                    .map(
                      (owner) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildOwnerCard(owner),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }

  Widget _buildOwnerCard(OwnerModel owner) {
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
        onTap: () => context.pushNamed(OwnerDetailPage.routeName, extra: owner),
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
              owner.lastName!.substring(0, 1).toUpperCase(),
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
          owner.fullName,
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
              'ID: ${owner.codeId} • ${owner.residence}',
              style:
                  TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
            if (owner.hasManagementAgents) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Avec agents',
                    style:
                        TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ).sourceSansProSemiBold,
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => context.pushNamed(CreateOwnerPage.routeName),
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
              'NOUVEAU',
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
