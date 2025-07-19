import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/shared/widgets/modals/index.dart';

class TenantDetailPage extends StatefulWidget {
  static const routeName = 'tenantDetail';
  static const routePath = '/tenant-detail/:id';

  final String tenantId;

  const TenantDetailPage({super.key, required this.tenantId});

  @override
  State<TenantDetailPage> createState() => _TenantDetailPageState();
}

class _TenantDetailPageState extends State<TenantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Détails du locataire',
      contentColor: AppColors.scaffold,
      content: _buildDetailContent(),
    );
  }

  // Header est désormais géré par FormWithHeaderLayout

  Widget _buildDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTenantInfoCard(),
        CustomSpacer(),
        _buildPropertyInfoCard(),
        Spacer(),
        _buildCollectRentButton(),
        SpacerPlatform()
      ],
    );
  }

  Widget _buildTenantInfoCard() {
    return _buildInfoCard(
      title: 'Données du locataire',
      child: Column(
        children: [
          _buildInfoRow(Icons.person, 'Nom : John Doe'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.email_outlined, 'Email : email@locataire.com'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.phone_outlined, 'Contact : +225 09898765454'),
        ],
      ),
    );
  }

  Widget _buildPropertyInfoCard() {
    return _buildInfoCard(
      title: 'Bien loué',
      child: Column(
        children: [
          _buildInfoRow(Icons.home_outlined, 'Type : villa'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.location_on_outlined, 'Localisation : Marcory'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.money_outlined, 'loyer : 200 000 FCFA'),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.calendar_today_outlined, 'Période : Juin 2025'),
          SizedBox(height: 16.sp),
          _buildInfoRow(
            Icons.money_outlined,
            'Montant dû : 200 000 FCFA',
            textColor: Colors.red[800],
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
            style:
                TextStyle(
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
                  color: Colors.black.withValues(alpha: 0.05),
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
        Text(
          text,
          style:
              TextStyle(
                fontSize: 16.sp,
                color: textColor ?? Colors.black87,
                fontWeight: fontWeight ?? FontWeight.normal,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildCollectRentButton() {
    return CustomButton(
      text: 'Encaisser le loyer',
      onPressed: () {
        showModalBottomSheet(
          showDragHandle: true,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          context: context,

          builder:
              (context) =>
                  ModalCollectingTheRent(onValidated: () {}, onCancel: () {}),
        );
      },
      showArrow: true,
      buttonVariant: ButtonVariant.red,
      textStyle:
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
    );
  }
}
