import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';

class ActivityDetailPage extends StatelessWidget {
  static const routeName = 'activityDetailCommercial';
  static const routePath = '/commercial/activity-detail';
  final ActivityModel activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerHeight: MediaQuery.of(context).size.height * .20,
      headerContent: Row(
        children: [
          const CircularBackButton(),
          SizedBox(width: 12.w),
          Text(
            'Détails de l\'activité',
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
        ],
      ),
      bodyContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActivityHeader(),
          SizedBox(height: 24.h),
          _buildInfoSection(),
          SizedBox(height: 32.h),
          // _buildActionButtons(context),
          // SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildActivityHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.sp),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.05),
                width: 6,
              ),
            ),
            child: Icon(activity.icon, color: AppColors.primary, size: 48.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            activity.title,
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ).sourceSansProBold,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            'INFORMATIONS GÉNÉRALES',
            style:
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 1.5,
                ).sourceSansProBold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailItem(
                Icons.description_outlined,
                'Description',
                activity.description,
              ),
              _divider(),
              _buildDetailItem(
                Icons.category_outlined,
                'Type d\'activité',
                activity.typeLabel,
              ),
              _divider(),
              _buildDetailItem(
                Icons.calendar_today_outlined,
                'Date de l\'action',
                '${activity.date.day.toString().padLeft(2, '0')}/${activity.date.month.toString().padLeft(2, '0')}/${activity.date.year}',
              ),
              _divider(),
              _buildDetailItem(
                Icons.access_time_outlined,
                'Heure précise',
                '${activity.date.hour.toString().padLeft(2, '0')}:${activity.date.minute.toString().padLeft(2, '0')}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.grey[600], size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style:
                      TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ).sourceSansProSemiBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.withValues(alpha: 0.08),
      indent: 48.w,
    );
  }
}
