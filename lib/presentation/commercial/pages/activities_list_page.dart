import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'activity_detail_page.dart';

class ActivitiesListPage extends StatelessWidget {
  static const routeName = 'activitiesListCommercial';
  static const routePath = '/commercial/activities';

  final List<ActivityModel>? externalActivities;

  ActivitiesListPage({super.key, this.externalActivities});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final activitiesFromState =
            state.commercialDashboardModel?.recentActivities
                ?.map((e) => e.toActivityModel())
                .toList() ??
            [];

        final displayActivities = externalActivities ?? activitiesFromState;

        return PageWithHeaderLayout(
          headerHeight: MediaQuery.of(context).size.height * .20,
          bodyPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 40.h),
          headerContent: Row(
            children: [
              const CircularBackButton(),
              SizedBox(width: 12.w),
              Text(
                externalActivities != null
                    ? 'Activités d\'aujourd\'hui'
                    : 'Toutes les activités',
                style:
                    TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).sourceSansProBold,
              ),
            ],
          ),
          bodyContent:
              displayActivities.isEmpty
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 64.sp,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            externalActivities != null
                                ? 'Aucune activité aujourd\'hui'
                                : 'Aucune activité enregistrée',
                            style:
                                TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[500],
                                ).sourceSansProRegular,
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayActivities.length,
                    separatorBuilder:
                        (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final activity = displayActivities[index];
                      return _buildActivityCard(context, activity);
                    },
                  ),
        );
      },
    );
  }

  Widget _buildActivityCard(BuildContext context, ActivityModel activity) {
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
            () => context.pushNamed(
              ActivityDetailPage.routeName,
              extra: activity,
            ),
        contentPadding: EdgeInsets.all(12.sp),
        leading: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(activity.icon, color: AppColors.primary, size: 24.sp),
        ),
        title: Text(
          activity.title,
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
              activity.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  activity.typeLabel,
                  style:
                      TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ).sourceSansProBold,
                ),
                SizedBox(width: 8.w),
                Text('•', style: TextStyle(color: Colors.grey[400])),
                SizedBox(width: 8.w),
                Text(
                  '#${activity.codeId}',
                  style:
                      TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      ),
    );
  }
}
