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
        return SizedBox(
          width: context.getSize.width,
          height: context.getSize.height,
          child: CinetPayCheckout(
            titleBackgroundColor: AppColors.scaffold,
            title: 'Guichet de paiement Maelys',
            configData: state.cinetpayData!.configData,
            paymentData: state.cinetpayData!.paymentData,
            waitResponse: (Map<String, dynamic> response) {
              print("CinetPayCheckout response :: ${response.toString()}");
              if (response.containsKey("status")) {
                if (response["status"].toString() == "ACCEPTED") {
                  showToast(
                    msg: "Votre paiement a été effectué avec succès",
                    type: ToastificationType.success,
                  );
                  context.goNamed(HomeTenantPage.routeName);
                } else {
                  showToast(msg: "Votre paiement a echoué");
                  context.pop();
                }
              } else {
                showToast(
                  msg: "Paiement en attente",
                  type: ToastificationType.warning,
                );
                context.goNamed(HomeTenantPage.routeName);
              }
            },
            onError: (error) {
              print("CinetPayCheckout error :: ${error.toString()}");
              showToast(msg: "Une erreur est survenue");
              context.pop();
            },
          ),
        );
      },
    );
  }
}
