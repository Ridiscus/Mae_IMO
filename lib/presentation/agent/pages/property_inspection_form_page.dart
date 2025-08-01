import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/shared/widgets/modals/index.dart';
import 'package:toastification/toastification.dart';

class PropertyInspectionFormPage extends StatefulWidget {
  static const routeName = 'propertyInspectionForm';
  static const routePath = '/property-inspection-form/:id';

  final String propertyId;

  const PropertyInspectionFormPage({super.key, required this.propertyId});

  @override
  State<PropertyInspectionFormPage> createState() =>
      _PropertyInspectionFormPageState();
}

class _PropertyInspectionFormPageState
    extends State<PropertyInspectionFormPage> {
  // Sample property rooms - to be replaced with actual data
  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Séjour',
      'status': null, // null = not set, true = good, false = bad
    },
    {'name': 'Cuisine', 'status': null},
    {'name': 'Chambre principale', 'status': null},
    {'name': 'Chambre secondaire', 'status': null},
    {'name': 'Salle de bain', 'status': null},
  ];

  // Additional comments
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

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
        _buildCommentsSection(),
        CustomSpacer(),
        _buildSaveButton(),
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
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.person_outline,
          label: 'Locataire: John Doe',
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
        SizedBox(height: 16.sp),
        ..._rooms.map((room) => _buildRoomItem(room)).toList(),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commentaires additionnels',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.sp),
        CustomInputTextFactory.createTextAreaInput(
          controller: _commentsController,
          hintText: 'Ajoutez des commentaires sur l\'état général du bien...',
          // maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return CustomButton(
      text: 'Enregistrer cet état',
      onPressed: _validateAndSave,
      showArrow: true,
      iconData: Icons.save,
    );
  }

  bool _isFormValid() {
    // Check if all rooms have a status selected
    for (var room in _rooms) {
      if (room['status'] == null) {
        return false;
      }
    }
    return true;
  }

  void _validateAndSave() {
    if (!_isFormValid()) {
      // Show error message
      showToast(
        msg: 'Veuillez sélectionner un état pour toutes les pièces',
        type: ToastificationType.error,
      );
      return;
    }

    // Show confirmation modal
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder:
          (context) => ModalPropertyInspectionConfirmation(
            onValidated: () {
              // Handle validation
              // Navigator.pop(context);

            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),
    );
  }
}
