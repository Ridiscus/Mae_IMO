import 'dart:developer' as console;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' show GoRoute;

import '../core/manager/state/auth/auth_bloc.dart';
import '../core/manager/state/dashboard/dashboard_bloc.dart';
import '../core/manager/state/payment/payment_bloc.dart';
import '../core/manager/token_manager.dart';
import '../presentation/auth/pages/forget_passord_page.dart';
import '../presentation/auth/pages/login_page.dart';
import '../presentation/auth/pages/reset_passord_page.dart';
import '../presentation/tenant/pages/dashboard_tenant_page.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routePath,
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) async {
        final userModel = context.read<AuthBloc>().state.userModel;
        final hasUserToken = await TokenManager().hasUserToken();

        console.log(
          "userModel ${userModel?.userType} && token $hasUserToken",
          name: "AuthRoutes",
        );

        if (userModel != null && hasUserToken) {
          if (userModel.isTenant) {
            context.read<PaymentBloc>().add(
              FetchHistoryPaymentEvent(tenantId: userModel.id!),
            );
            context.read<DashboardBloc>().add(FetchTenantDashboardEvent());
            return DashboardTenantPage.routePath;
          }
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      name: ForgetPasswordPage.routeName,
      path: ForgetPasswordPage.routePath,
      builder: (context, state) => const ForgetPasswordPage(),
    ),
    GoRoute(
      name: ResetPasswordPage.routeName,
      path: ResetPasswordPage.routePath,
      builder: (context, state) => const ResetPasswordPage(),
    ),
  ];
}
