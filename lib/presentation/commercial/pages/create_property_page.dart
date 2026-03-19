import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'create_agency_property_page.dart';
import 'create_owner_property_page.dart';

class CreatePropertyPage extends StatelessWidget {
  static const routeName = 'createProperty';
  static const routePath = '/commercial/add-property';

  const CreatePropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Ajouter un Bien',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            'POUR QUI SOUHAITEZ-VOUS CRÉER CE BIEN ?',
            style:
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.1,
                ).sourceSansProBold,
          ),
          SizedBox(height: 24.h),
          _buildSelectionCard(
            context,
            title: 'Pour une Agence',
            description:
                'Le bien sera rattaché à une agence immobilière partenaire.',
            icon: Icons.business_outlined,
            color: AppColors.primary,
            onTap: () => context.pushNamed(CreateAgencyPropertyPage.routeName),
          ),
          SizedBox(height: 16.h),
          _buildSelectionCard(
            context,
            title: 'Pour un Propriétaire',
            description:
                'Le bien sera rattaché directement à un propriétaire particulier.',
            icon: Icons.person_outline,
            color: AppColors.orange,
            onTap: () => context.pushNamed(CreateOwnerPropertyPage.routeName),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30.sp),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ).sourceSansProBold,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style:
                          TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                          ).sourceSansProRegular,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[300],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
