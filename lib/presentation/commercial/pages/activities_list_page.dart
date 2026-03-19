import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'activity_detail_page.dart';

class ActivitiesListPage extends StatelessWidget {
  static const routeName = 'activitiesListCommercial';
  static const routePath = '/commercial/activities';

  ActivitiesListPage({super.key});

  final List<ActivityModel> activities = [
    ActivityModel(
      id: 1,
      codeId: 'AG4021',
      title: 'Agence Horizon',
      description: 'Nouvelle agence partenaire enregistrée avec succès.',
      type: ActivityType.agency,
      date: DateTime(2024, 3, 12),
    ),
    ActivityModel(
      id: 2,
      codeId: 'PR2209',
      title: 'M. Koffi Kouadio',
      description: 'Mise à jour des informations de contact du propriétaire.',
      type: ActivityType.owner,
      date: DateTime(2024, 3, 11),
    ),
    ActivityModel(
      id: 3,
      codeId: 'B8832',
      title: 'Résidence Prestige',
      description: 'Nouveau bien immobilier ajouté au catalogue.',
      type: ActivityType.property,
      date: DateTime(2024, 3, 10),
    ),
    ActivityModel(
      id: 4,
      codeId: 'AG3910',
      title: 'Immo Concept',
      description: 'Renouvellement du contrat de partenariat.',
      type: ActivityType.agency,
      date: DateTime(2024, 3, 9),
    ),
    ActivityModel(
      id: 5,
      codeId: 'PR1102',
      title: 'Mme. Awa Koné',
      description: 'Enregistrement d\'un nouveau propriétaire.',
      type: ActivityType.owner,
      date: DateTime(2024, 3, 8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerHeight: MediaQuery.of(context).size.height * .20,
      bodyPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 40.h),
      headerContent: Row(
        children: [
          const CircularBackButton(),
          SizedBox(width: 12.w),
          Text(
            'Toutes les activités',
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
        ],
      ),
      bodyContent: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return _buildActivityCard(context, activity);
        },
      ),
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
