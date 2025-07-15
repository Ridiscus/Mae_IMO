import 'package:go_router/go_router.dart' show GoRoute;
import '../presentation/tenant/pages/contact_agency_page.dart';
import '../presentation/tenant/pages/home_tenant_page.dart';
import '../presentation/tenant/pages/payment_page.dart';
import '../presentation/tenant/pages/profile_tenant_page.dart';

class TenantRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: HomeTenantPage.routeName,
      path: HomeTenantPage.routePath,
      builder: (context, state) => const HomeTenantPage(),
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
  ];
}
