import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PropertyInspectionPage extends StatefulWidget {
  static const routeName = 'propertyInspectionPage';
  static const routePath = '/property-inspection';

  const PropertyInspectionPage({super.key});

  @override
  State<PropertyInspectionPage> createState() => _PropertyInspectionPageState();
}

class _PropertyInspectionPageState extends State<PropertyInspectionPage> {
  // Sample property rooms - to be replaced with actual data
  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Séjour',
      'status': true, // null = not set, true = good, false = bad
    },
    {'name': 'Cuisine', 'status': true},
    {'name': 'Chambre principale', 'status': false},
    {'name': 'Chambre secondaire', 'status': false},
    {'name': 'Salle de bain', 'status': false},
  ];


  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerContent: _buildHeaderContent(),
      bodyContent: _buildInspectionForm(),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircularBackButton(),
        CustomSpacer(),
        Text(
          'État des lieux',
          style:
              TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildInspectionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertySummary(),
        CustomSpacer(space: 2),
        _buildRoomsList(),
        CustomSpacer(),
      ],
    );
  }

  Widget _buildPropertySummary() {
    // Sample property data - replace with actual data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Villa Marcory',
          style:
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(icon: Icons.home_outlined, label: 'Type: Villa'),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Adresse: Marcory, Abidjan',
        ),
      ],
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: Colors.black87),
        SizedBox(width: 12.sp),
        Text(
          label,
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildRoomsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'État des pièces',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        CustomSpacer(),
        ..._rooms.map((room) => _buildRoomItem(room)),
      ],
    );
  }

  Widget _buildRoomItem(Map<String, dynamic> room) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room['name'],
            style:
                TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ).sourceSansProSemiBold,
          ),
          SizedBox(height: 12.sp),
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                  label: 'Bon état',
                  isSelected: room['status'] == true,
                  color: AppColors.success,
                  onTap: () {
                    setState(() {
                      room['status'] = true;
                    });
                  },
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: _buildStatusButton(
                  label: 'Mauvais état',
                  isSelected: room['status'] == false,
                  color: AppColors.redColor,
                  onTap: () {
                    setState(() {
                      room['status'] = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      decoration: BoxDecoration(
        color:
            isSelected
                ? color.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withOpacity(0.3),
          width: 1.sp,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          label,
          style:
              TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ).sourceSansProSemiBold,
        ),
      ),
    );
  }
}
