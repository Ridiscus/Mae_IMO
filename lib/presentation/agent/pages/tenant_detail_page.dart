import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/tenant/tenant_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/shared/widgets/modals/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/domain/models/index.dart';

class TenantDetailPage extends StatefulWidget {
  static const routeName = 'tenantDetail';
  static const routePath = '/tenant-detail/:id';

  final String tenantId;

  const TenantDetailPage({super.key, required this.tenantId});

  @override
  State<TenantDetailPage> createState() => _TenantDetailPageState();
}

class _TenantDetailPageState extends State<TenantDetailPage> {
  late TenantState _tenantState;
  TenantDetailModel? _tenant;
  bool _isLoading = false;

  bool get allReadyPay =>
      (_tenant?.prochainMoisAPayer?.dejaPaye ?? false) ||
      (_tenant?.prochainMoisAPayer?.moisCouvert?.thisMountIncluded() ?? false);

  @override
  Widget build(BuildContext context) {
    _tenantState = context.select((TenantBloc bloc) => bloc.state);
    _tenant = _tenantState.tenant;
    _isLoading = _tenantState.isLoading ?? false;

    return BlocListener<TenantBloc, TenantState>(
      listener: (context, state) {
        if (state.isLoading == false &&
            state.tenant == null &&
            state.failure == null) {
          if (kDebugMode) {
          } else {
            context.pop();
          }
        }
      },
      child: FormWithHeaderLayout(
        headerTitle: 'Détails du locataire',
        contentColor: AppColors.scaffold,
        content: _buildDetailContent(),
      ),
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
    return Skeletonizer(
      enabled: _isLoading,
      child: InfoCardWidget(
        title: 'Données du locataire',
        child: Column(
          children: [
            InfoRowWidget(
              icon: Icons.person,
              text: 'Nom : ${_tenant?.locataire?.fullName ?? ''}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.email_outlined,
              text: 'Email : ${_tenant?.locataire?.email ?? ''}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.phone_outlined,
              text: 'Contact : ${_tenant?.locataire?.contact ?? ''}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyInfoCard() {
    return Skeletonizer(
      enabled: _isLoading,
      child: InfoCardWidget(
        title: 'Bien loué',
        child: Column(
          children: [
            InfoRowWidget(
              icon: Icons.home_outlined,
              text: 'Type : ${_tenant?.bien?.type ?? ''}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.location_on_outlined,
              text: 'Localisation : ${_tenant?.bien?.commune ?? ''}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.money_outlined,
              text: 'loyer : ${(_tenant?.bien?.prix ?? '').formatCurrency()}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.calendar_today_outlined,
              text:
                  'Période : ${_tenant?.prochainMoisAPayer?.moisCouvert?.monthYear() ?? ''}',
            ),
            SizedBox(height: 16.sp),
            InfoRowWidget(
              icon: Icons.money_outlined,
              text:
                  '${allReadyPay ? 'Montant payé' : 'Montant dû'}: ${_tenant?.prochainMoisAPayer?.montant?.formatCurrency() ?? ''}',
              textColor: allReadyPay ? AppColors.success : Colors.red[800],
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectRentButton() {
    return allReadyPay
        ? SizedBox.shrink()
        : CustomButton(
          text: 'Encaisser le loyer',
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              backgroundColor: Colors.white,
              isScrollControlled: true,
              context: context,
              builder:
                  (context) => ModalCollectingTheRent(
                    tenantId: int.tryParse(widget.tenantId) ?? 0,
                    amount: _tenant?.bien?.prix?.toString() ?? '0',
                    onValidated: () {
                      // Callback appelé après validation réussie
                      if (kDebugMode) {
                        print('Paiement validé avec succès');
                      }
                    },
                    onCancel: () {
                      // Callback appelé en cas d'annulation
                      Navigator.pop(context);
                    },
                  ),
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
