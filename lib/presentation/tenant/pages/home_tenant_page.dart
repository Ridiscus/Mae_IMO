import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/manager/state/payment/payment_bloc.dart';
import 'package:maelys_imo/presentation/tenant/pages/payment_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/shared/widgets/modals/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/domain/models/index.dart';
import '../../../core/manager/state/auth/auth_bloc.dart';

class HomeTenantPage extends StatefulWidget {
  static const routeName = 'homeTenant';
  static const routePath = '/home-tenant';

  const HomeTenantPage({super.key});

  @override
  State<HomeTenantPage> createState() => _HomeTenantPageState();
}

class _HomeTenantPageState extends State<HomeTenantPage> {
  late UserModel _userModel;
  late AuthState _authState;
  late PaymentState _paymentState;
  bool _loadingAll = true;

  late TenantDashboardModel _tenantDashboardModel;

  bool thisMountIncluded = false;

  /// Affiche le modal avec les détails du paiement
  void _showPaymentDetails({
    required String month,
    required String amount,
    required String date,
    required String paymentMethod,
    required String reference,
    required PaymentStatusModel status,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.transparent,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder:
          (context) => ModalPaymentInfo(
            month: month,
            amount: amount,
            status: status,
            date: date,
            reference: reference,
            paymentMethod: paymentMethod,
            recipientName: '${_tenantDashboardModel.locataire?.agency?.name}',
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _authState = context.select((AuthBloc bloc) => bloc.state);
    _paymentState = context.select((PaymentBloc bloc) => bloc.state);
    _tenantDashboardModel =
        context.select(
          (DashboardBloc bloc) => bloc.state.tenantDashboardModel,
        )!;

    _userModel = _authState.userModel!;
    _loadingAll = _authState.isLoading || _paymentState.isLoading;

    thisMountIncluded =
        (_paymentState.paymentHistoryModel ?? [])
            .where((element) => (element.moisCouvert ?? "").thisMountIncluded())
            .isNotEmpty;

    return PageWithHeaderLayout(
      headerContent: _buildHeaderContent(),
      bodyContent: _buildContent(),
      onRefresh: () async {
        final completer = Completer<void>();

        // Écouter les changements d'état pour savoir quand le chargement est terminé
        late StreamSubscription subscription;
        subscription = context.read<PaymentBloc>().stream.listen((state) {
          if (state.isLoading) {
            subscription.cancel();
            completer.complete();
          }
        });

        // Déclencher le chargement des données
        context.read<PaymentBloc>().add(
          FetchHistoryPaymentEvent(tenantId: _userModel.id!),
        );

        // Attendre que le chargement soit terminé
        return completer.future;
      },
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircularBackButton(), // Retiré car dans le shell de navigation
            Text(
              DateTime.now().monthYear().firstLetter(),
              style:
                  TextStyle(
                    fontSize: 20.r,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).sourceSansProBold,
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 24.r),
            // Ajout d'un espace pour équilibrer la mise en page
            // CircularIcon(
            //   iconAsset: Assets.user,
            //   onPressed: () {
            //     context.pushNamed(ProfileTenantPage.routeName);
            //   },
            // ),
          ],
        ),
        CustomSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildRentInfo(),

            if (_tenantDashboardModel.qrCode != null)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    showDragHandle: true,
                    useSafeArea: true,
                    builder: (context) => ModalQrCode(),
                  );
                },
                child: CustomQrCodeView(),
              ),
          ],
        ),
        CustomSpacer(),
        _buildPayRentButton(),
      ],
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

            CustomTag(
              label: thisMountIncluded ? 'Payé' : 'impayé',
              color: thisMountIncluded ? AppColors.success : AppColors.redColor,
            ),
          ],
        ),
        Text(
          '${_tenantDashboardModel.locataire?.estate?.prix}'.formatCurrency(),
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
    final paymentHistory = _paymentState.paymentHistoryModel ?? [];
    return (paymentHistory.isEmpty)
        ? SizedBox(
          height: context.getSize.height,
          child: EmptyStateWidget(
            title: "Aucun paiement trouvé !",
            icon: Icons.search_off,
          ),
        )
        : Column(
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
            ...paymentHistory
                .map((payment) {
                  return Skeletonizer(
                    enabled: _paymentState.isLoading,
                    child: _buildPaymentHistoryItem(payment: payment),
                  );
                })
                .expand((element) => [element, CustomSpacer(space: .5)]),
          ],
        );
  }

  Widget _buildPaymentHistoryItem({required PaymentHistoryModel payment}) {
    var month = (payment.moisCouvert as String).monthYear();
    var amount = (payment.montant as String).formatCurrency();
    var date = payment.datePaiement?.humanWithoutTime() ?? "";
    var paymentMethod = (payment.methodePaiement as String);
    var reference = (payment.reference as String);
    var status = PaymentStatusModel.fromText(payment.statut);
    // En attente
    return GestureDetector(
      onTap:
          () => _showPaymentDetails(
            month: month,
            amount: amount,
            date: date,
            paymentMethod: paymentMethod,
            reference: reference,
            status: status,
          ),
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
            SizedBox(width: 12.r),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loyer de $month',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTag(label: status.label, color: status.color),
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
}
