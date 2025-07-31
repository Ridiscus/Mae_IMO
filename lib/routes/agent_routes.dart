import 'package:go_router/go_router.dart' show GoRoute;

import '../presentation/agent/pages/home_agent_page.dart';
import '../presentation/agent/pages/profile_agent_page.dart';
import '../presentation/agent/pages/tenant_detail_page.dart';
import '../presentation/agent/pages/tenant_list_page.dart';
import '../presentation/agent/pages/property_inspection_list_page.dart';
import '../presentation/agent/pages/property_inspection_detail_page.dart';
import '../presentation/agent/pages/property_inspection_form_page.dart';

class AgentRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: HomeAgentPage.routeName,
      path: HomeAgentPage.routePath,
      builder: (context, state) => const HomeAgentPage(),
    ),
    GoRoute(
      name: TenantListPage.routeName,
      path: TenantListPage.routePath,
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? 'late';
        TenantListType listType;

        switch (type) {
          case 'up-to-date':
            listType = TenantListType.upToDate;
            break;
          case 'pending':
            listType = TenantListType.pendingPayment;
            break;
          case 'late':
          default:
            listType = TenantListType.late;
        }

        return TenantListPage(listType: listType);
      },
    ),
    GoRoute(
      name: TenantDetailPage.routeName,
      path: TenantDetailPage.routePath,
      builder: (context, state) {
        final tenantId = state.pathParameters['id'] ?? '';
        return TenantDetailPage(tenantId: tenantId);
      },
    ),
    GoRoute(
      name: ProfileAgentPage.routeName,
      path: ProfileAgentPage.routePath,
      builder: (context, state) => const ProfileAgentPage(),
    ),
    // Property Inspection Routes
    GoRoute(
      name: PropertyInspectionListPage.routeName,
      path: PropertyInspectionListPage.routePath,
      builder: (context, state) => const PropertyInspectionListPage(),
    ),
    GoRoute(
      name: PropertyInspectionDetailPage.routeName,
      path: PropertyInspectionDetailPage.routePath,
      builder: (context, state) {
        final propertyId = state.pathParameters['id'] ?? '';
        return PropertyInspectionDetailPage(propertyId: propertyId);
      },
    ),
    GoRoute(
      name: PropertyInspectionFormPage.routeName,
      path: PropertyInspectionFormPage.routePath,
      builder: (context, state) {
        final propertyId = state.pathParameters['id'] ?? '';
        return PropertyInspectionFormPage(propertyId: propertyId);
      },
    ),
  ];
}
