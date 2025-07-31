import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/property_inspection_form_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PropertyInspectionDetailPage extends StatefulWidget {
  static const routeName = 'propertyInspectionDetail';
  static const routePath = '/property-inspection-detail/:id';

  final String propertyId;

  const PropertyInspectionDetailPage({super.key, required this.propertyId});

  @override
  State<PropertyInspectionDetailPage> createState() => _PropertyInspectionDetailPageState();
}

class _PropertyInspectionDetailPageState extends State<PropertyInspectionDetailPage> {
  // Sample property data - to be replaced with API data
  final Map<String, dynamic> _propertyData = {
    'propertyName': 'Villa Marcory',
    'tenantName': 'John Doe',
    'address': 'Marcory, Abidjan',
    'propertyType': 'Villa',
    'rooms': 4,
    'bathrooms': 2,
    'status': 'En attente',
  };

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Détails de l\'état des lieux',
      contentColor: AppColors.scaffold,
      content: _buildDetailContent(),
    );
  }

  Widget _buildDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertyInfoCard(),
        CustomSpacer(),
        _buildTenantInfoCard(),
        Spacer(),
        _buildStartInspectionButton(),
        SpacerPlatform()
      ],
    );
  }

  Widget _buildPropertyInfoCard() {
    return _buildInfoCard(
      title: 'Données du bien',
      child: Column(
        children: [
          _buildInfoRow(Icons.home_outlined, 'Nom: ${_propertyData['propertyName']}'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.location_on_outlined, 'Adresse: ${_propertyData['address']}'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.house_outlined, 'Type: ${_propertyData['propertyType']}'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.meeting_room_outlined, 'Chambres: ${_propertyData['rooms']}'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.bathroom_outlined, 'Salles de bain: ${_propertyData['bathrooms']}'),
        ],
      ),
    );
  }

  Widget _buildTenantInfoCard() {
    return _buildInfoCard(
      title: 'Données du locataire',
      child: Column(
        children: [
          _buildInfoRow(Icons.person_outline, 'Nom: ${_propertyData['tenantName']}'),
          SizedBox(height: 16.sp),
          _buildInfoRow(
            Icons.pending_actions_outlined, 
            'Statut: ${_propertyData['status']}',
            textColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ).sourceSansProBold,
          ),
          CustomSpacer(space: .5),
          Container(
            padding: EdgeInsets.all(16.sp),
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
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text, {
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: textColor ?? Colors.black87),
        SizedBox(width: 16.sp),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color: textColor ?? Colors.black87,
              fontWeight: fontWeight ?? FontWeight.normal,
            ).sourceSansProRegular,
          ),
        ),
      ],
    );
  }

  Widget _buildStartInspectionButton() {
    return CustomButton(
      text: 'Démarrer l\'état des lieux',
      onPressed: () {
        // Navigate to the inspection form page
        context.pushNamed(
          PropertyInspectionFormPage.routeName,
          pathParameters: {'id': widget.propertyId},
        );
      },
      showArrow: true,
      buttonVariant: ButtonVariant.primary,
    );
  }
}
