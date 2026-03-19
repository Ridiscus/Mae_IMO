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
          SizedBox(height: 30.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActivityHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, color: AppColors.primary, size: 40.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            activity.title,
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ).sourceSansProBold,
          ),
          SizedBox(height: 4.h),
          Text(
            '${activity.typeLabel} • #${activity.codeId}',
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(20.sp),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPTION',
            style:
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                  letterSpacing: 1.2,
                ).sourceSansProBold,
          ),
          SizedBox(height: 12.h),
          Text(
            activity.description,
            style:
                TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  height: 1.5,
                ).sourceSansProRegular,
          ),
          Divider(height: 32.h, color: Colors.grey[100]),
          _buildInfoRow(
            'Date',
            '${activity.date.day.toString().padLeft(2, '0')}/${activity.date.month.toString().padLeft(2, '0')}/${activity.date.year}',
          ),
          _buildInfoRow('Heure', '14:30'), // Mock time
          _buildInfoRow('Statut', 'Terminé', valueColor: AppColors.success),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
          Text(
            value,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ).sourceSansProBold,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'VOIR L\'ÉLÉMENT LIÉ',
          onPressed: () {
            // Logic to navigate to Agency/Owner/Property detail would go here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Redirection vers l\'élément lié...'),
              ),
            );
          },
        ),
      ],
    );
  }
}
