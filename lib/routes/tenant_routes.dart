import 'package:go_router/go_router.dart' show GoRoute;
import 'package:maelys_imo/presentation/tenant/pages/update_email_page.dart';

import '../presentation/tenant/pages/contact_agency_page.dart';
import '../presentation/tenant/pages/dashboard_tenant_page.dart';
import '../presentation/tenant/pages/payment_page.dart';
import '../presentation/tenant/pages/profile_tenant_page.dart';
import '../presentation/tenant/pages/update_password_page.dart';

class TenantRoutes {
  static List<GoRoute> routes = [
    // NOTE: Les routes pour DocumentsTenantPage, HomeTenantPage et PropertyInspectionPage
    // sont maintenant gérées par le TenantShellRoutes avec StatefulShellRoute
    GoRoute(
      name: DashboardTenantPage.routeName,
      path: DashboardTenantPage.routePath,
      // Cette route est maintenant utilisée pour rediriger vers la première branche du shell (Dashboard/Accueil)
      redirect: (context, state) => '/dashboard',
    ),
    GoRoute(
      name: ProfileTenantPage.routeName,
      path: ProfileTenantPage.routePath,
      builder: (context, state) => const ProfileTenantPage(),
    ),

    GoRoute(
      name: PaymentPage.routeName,
      path: PaymentPage.routePath,
      builder: (context, state) => const PaymentPage(),
    ),
    GoRoute(
      name: ContactAgencyPage.routeName,
      path: ContactAgencyPage.routePath,
      builder: (context, state) => const ContactAgencyPage(),
    ),
    GoRoute(
      name: UpdateEmailPage.routeName,
      path: UpdateEmailPage.routePath,
      builder: (context, state) => const UpdateEmailPage(),
    ),
    GoRoute(
      name: UpdatePasswordPage.routeName,
      path: UpdatePasswordPage.routePath,
      builder: (context, state) => const UpdatePasswordPage(),
    ),
  ];
}
