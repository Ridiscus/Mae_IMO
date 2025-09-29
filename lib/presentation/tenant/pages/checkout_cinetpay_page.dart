import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/payment/payment_bloc.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:toastification/toastification.dart';

import 'home_tenant_page.dart';

class CheckoutCinetpayPage extends StatefulWidget {
  static const routeName = 'CheckoutCinetpay';
  static const routePath = '/checkout-cinetpay';

  const CheckoutCinetpayPage({super.key});

  @override
  State<CheckoutCinetpayPage> createState() => _CheckoutCinetpayPageState();
}

class _CheckoutCinetpayPageState extends State<CheckoutCinetpayPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        setState(() {
          isLoading = state.isLoading;
        });
      },
      builder: (context, state) {
        // Guard: show loader while config is not yet available
        if (state.cinetpayData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          width: context.getSize.width,
          height: context.getSize.height,
          child: CinetPayCheckout(
            titleBackgroundColor: AppColors.scaffold,
            title: 'Guichet de paiement Maelys',
            configData: state.cinetpayData!.configData,
            paymentData: state.cinetpayData!.paymentData,
            waitResponse: (Map<String, dynamic>? response) {
              // Log the raw response for diagnostics
              print("CinetPayCheckout response :: ${response.toString()}");

              try {
                final status = response != null ? response["status"]?.toString() : null;

                if (status == "ACCEPTED") {
                  showToast(
                    msg: "Votre paiement a été effectué avec succès",
                    type: ToastificationType.success,
                  );
                  if (!mounted) return;
                  context.goNamed(HomeTenantPage.routeName);
                } else if (status == null) {
                  // Pending or no status returned yet
                  showToast(
                    msg: "Paiement en attente",
                    type: ToastificationType.warning,
                  );
                  if (!mounted) return;
                  context.goNamed(HomeTenantPage.routeName);
                } else {
                  // DECLINED or any non-accepted state
                  showToast(msg: "Votre paiement a échoué");
                  if (!mounted) return;
                  context.pop();
                }
              } catch (e) {
                print("CinetPay waitResponse handling error :: ${e.toString()}");
                showToast(msg: "Une erreur est survenue pendant le traitement");
                if (!mounted) return;
                context.pop();
              }
            },
            onError: (error) {
              print("CinetPayCheckout error :: ${error.toString()}");
              showToast(msg: "Une erreur est survenue");
              if (!mounted) return;
              context.pop();
            },
          ),
        );
      },
    );
  }
}
