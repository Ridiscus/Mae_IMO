import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/tenant/pages/contact_agency_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/payment_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/profile_tenant_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/shared/widgets/modals/index.dart';

class HomeTenantPage extends StatefulWidget {
  static const routeName = 'homeTenant';
  static const routePath = '/home-tenant';

  const HomeTenantPage({super.key});

  @override
  State<HomeTenantPage> createState() => _HomeTenantPageState();
}

class _HomeTenantPageState extends State<HomeTenantPage> {
  /// Affiche le modal avec les détails du paiement
  void _showPaymentDetails(
    String month,
    String amount,
    String date,
    bool isPaid,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ModalPaymentInfo(
            month: month,
            amount: amount,
            date: date,
            isPaid: isPaid,
            reference:
                'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
            paymentMethod: isPaid ? 'Carte bancaire' : null,
            recipientName: isPaid ? 'Agence Maelys Immo' : null,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [_buildHeader(), Expanded(child: _buildContent())],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildContactButton(),
    );
  }

  Widget _buildHeader() {
    return AppHeaderLayout(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                'Juillet 2025',
                style: TextStyle(
                  fontSize: 20.r,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white, size: 24.r),
              Spacer(),
              CircularIcon(
                iconAsset: Assets.user,
                onPressed: () {
                  context.pushNamed(ProfileTenantPage.routeName);
                },
              ),
            ],
          ),
          CustomSpacer(),
          _buildRentInfo(),
          CustomSpacer(),
          _buildPayRentButton(),
        ],
      ),
    );
  }

  Widget _buildRentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Loyer du mois',
              style:
                  TextStyle(
                    fontSize: 16.r,
                    color: Colors.white,
                  ).sourceSansProRegular,
            ),
            CustomSpacer(space: .5, isVertical: false),

            CustomTag(label: 'impayé', color: AppColors.redColor),
          ],
        ),
        Text(
          '200 000 FCFA',
          style:
              TextStyle(
                fontSize: 32.r,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildPayRentButton() {
    return CustomButton(
      text: "Payer mon loyer",
      showArrow: true,
      onPressed: () {
        context.pushNamed(PaymentPage.routeName);
      },
      assetPath: Assets.monney,
      buttonVariant: ButtonVariant.orange,
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      color: AppColors.scaffold,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historique des paiements',
                style:
                    TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ).sourceSansProSemiBold,
              ),
              CustomSpacer(),
              _buildPaymentHistoryItem(
                month: 'juin',
                amount: '200 000 FCFA',
                date: '06 juin 2025',
                isPaid: true,
              ),
              CustomSpacer(),

              _buildPaymentHistoryItem(
                month: 'mai',
                amount: '200 000 FCFA',
                date: '06 juin 2025',
                isPaid: true,
              ),
              CustomSpacer(),

              _buildPaymentHistoryItem(
                month: 'avril',
                amount: '150 000 FCFA',
                date: '06 juin 2025',
                isPaid: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem({
    required String month,
    required String amount,
    required String date,
    required bool isPaid,
  }) {
    return GestureDetector(
      onTap: () => _showPaymentDetails(month, amount, date, isPaid),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.image, color: Colors.grey[600]),
            ),
            SizedBox(width: 16.r),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loyer du mois de $month',
                    style:
                        TextStyle(
                          fontSize: 16.r,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ).sourceSansProSemiBold,
                  ),
                  CustomSpacer(space: .2),
                  Text(
                    amount,
                    style:
                        TextStyle(
                          fontSize: 18.r,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ).sourceSansProBold,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTag(
                  label: isPaid ? 'Payé' : 'Impayé',
                  color: isPaid ? AppColors.success : AppColors.redColor,
                ),
                CustomSpacer(space: .2),
                Text(
                  date,
                  style:
                      TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ).sourceSansProRegular,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
            text: "Contacter l'agence",
            showArrow: true,
            onPressed: () {
              context.pushNamed(ContactAgencyPage.routeName);
            },
            assetPath: Assets.phone,
            buttonVariant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
