import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/property_inspection_detail_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PropertyInspectionListPage extends StatefulWidget {
  static const routeName = 'propertyInspectionList';
  static const routePath = '/property-inspection-list';

  const PropertyInspectionListPage({super.key});

  @override
  State<PropertyInspectionListPage> createState() =>
      _PropertyInspectionListPageState();
}

class _PropertyInspectionListPageState
    extends State<PropertyInspectionListPage> {
  // Sample data - to be replaced with actual data from API
  final List<Map<String, dynamic>> _inspections = [
    {
      'id': '1',
      'propertyName': 'Villa Marcory',
      'tenantName': 'John Doe',
      'address': 'Marcory, Abidjan',
      'date': '15/08/2025',
      'status': 'En attente',
    },
    {
      'id': '2',
      'propertyName': 'Appartement Cocody',
      'tenantName': 'Jane Smith',
      'address': 'Cocody, Abidjan',
      'date': '18/08/2025',
      'status': 'En attente',
    },
    {
      'id': '3',
      'propertyName': 'Studio Yopougon',
      'tenantName': 'Robert Johnson',
      'address': 'Yopougon, Abidjan',
      'date': '20/08/2025',
      'status': 'En attente',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'États des lieux',
      contentColor: AppColors.scaffold,
      content: _buildContent(),
      // content: Column(),
    );
  }

  Widget _buildContent() {
    return _inspections.isEmpty
        ? _buildEmptyState()
        : Column(
          children: [
            ..._inspections
                .map((inspection) {
                  return _buildInspectionCard(inspection);
                })
                .expand((element) => [element, CustomSpacer()]),
          ],
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 80.sp,
            color: AppColors.primary.withOpacity(0.5),
          ),
          SizedBox(height: 16.sp),
          Text(
            'Aucun état des lieux en attente',
            style:
                TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black87,
                ).sourceSansProSemiBold,
          ),
          SizedBox(height: 8.sp),
          Text(
            'Vous n\'avez aucun état des lieux à effectuer pour le moment',
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ).sourceSansProRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionCard(Map<String, dynamic> inspection) {
    return GestureDetector(
      onTap: () {
        // Navigate to inspection detail page
        context.pushNamed(
          PropertyInspectionDetailPage.routeName,
          pathParameters: {'id': inspection['id']},
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      inspection['propertyName'],
                      style:
                          TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ).sourceSansProBold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.sp,
                      vertical: 4.sp,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      inspection['status'],
                      style:
                          TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ).sourceSansProSemiBold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.sp),
              _buildInfoRow(
                Icons.person_outline,
                'Locataire: ${inspection['tenantName']}',
              ),
              SizedBox(height: 8.sp),
              _buildInfoRow(Icons.location_on_outlined, inspection['address']),
              SizedBox(height: 8.sp),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Prévu le: ${inspection['date']}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.black54),
        SizedBox(width: 8.sp),
        Expanded(
          child: Text(
            text,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ).sourceSansProRegular,
          ),
        ),
      ],
    );
  }
}
