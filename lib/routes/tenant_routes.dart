import 'package:go_router/go_router.dart' show GoRoute;
import '../presentation/tenant/pages/contact_agency_page.dart';
import '../presentation/tenant/pages/dashboard_tenant_page.dart';
import '../presentation/tenant/pages/document_tenant_page.dart';
import '../presentation/tenant/pages/home_tenant_page.dart';
import '../presentation/tenant/pages/payment_page.dart';
import '../presentation/tenant/pages/profile_tenant_page.dart';
import '../presentation/tenant/pages/property_inspection_page.dart';

class TenantRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: DashboardTenantPage.routeName,
      path: DashboardTenantPage.routePath,
      builder: (context, state) => const DashboardTenantPage(),
    ),
    GoRoute(
      name: DocumentsTenantPage.routeName,
      path: DocumentsTenantPage.routePath,
      builder: (context, state) => const DocumentsTenantPage(),
    ),
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
    GoRoute(
      name: PropertyInspectionPage.routeName,
      path: PropertyInspectionPage.routePath,
      builder: (context, state) => const PropertyInspectionPage(

      ),
    ),
  ];
}
