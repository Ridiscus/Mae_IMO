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
        SpacerPlatform(),
      ],
    );
  }

  Widget _buildTenantInfoCard() {
    return InfoCardWidget(
      title: 'Données du locataire',
      child: Column(
        children: [
          InfoRowWidget(icon:  Icons.person,  text: 'Nom : John Doe'),
          SizedBox(height: 16.sp),
          InfoRowWidget(icon:  Icons.email_outlined, text:  'Email : email@locataire.com'),
          SizedBox(height: 16.sp),
          InfoRowWidget(icon:  Icons.phone_outlined, text:  'Contact : +225 09898765454'),
        ],
      ),
    );
  }

  Widget _buildPropertyInfoCard() {
    return InfoCardWidget(
      title: 'Bien loué',
      child: Column(
        children: [
          InfoRowWidget(icon: Icons.home_outlined, text: 'Type : villa'),
          SizedBox(height: 16.sp),
          InfoRowWidget(
            icon: Icons.location_on_outlined,
            text: 'Localisation : Marcory',
          ),
          SizedBox(height: 16.sp),
          InfoRowWidget(
            icon: Icons.money_outlined,
            text: 'loyer : 200 000 FCFA',
          ),
          SizedBox(height: 16.sp),
          InfoRowWidget(
            icon: Icons.calendar_today_outlined,
            text: 'Période : Juin 2025',
          ),
          SizedBox(height: 16.sp),
          InfoRowWidget(
            icon: Icons.money_outlined,
            text: 'Montant dû : 200 000 FCFA',
            textColor: Colors.red[800],
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
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
