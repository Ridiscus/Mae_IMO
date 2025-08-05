import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/tenant/pages/dashboard_content_page.dart';
import '../presentation/tenant/pages/dashboard_tenant_page.dart';
import '../presentation/tenant/pages/document_tenant_page.dart';
import '../presentation/tenant/pages/home_tenant_page.dart';
import '../presentation/tenant/pages/property_inspection_page.dart';

class TenantShellRoutes {
  // Routes principales pour la shell navigation
  static final List<RouteBase> routes = [
    // StatefulShellRoute pour la barre de navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Retourne notre page de dashboard qui contient le bottom nav bar
        return DashboardTenantPage(
          navigationShell: navigationShell,
        );
      },
      branches: [
        // Branche Accueil (Dashboard)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: DashboardContentPage.routePath,
              name: DashboardContentPage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DashboardContentPage(),
              ),
            ),
          ],
        ),
        
        // Branche Documents
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: DocumentsTenantPage.routePath,
              name: DocumentsTenantPage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DocumentsTenantPage(),
              ),
            ),
          ],
        ),
        
        // Branche Paiements
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomeTenantPage.routePath,
              name: HomeTenantPage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeTenantPage(),
              ),
            ),
          ],
        ),
        
        // Branche État des lieux
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: PropertyInspectionPage.routePath,
              name: PropertyInspectionPage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PropertyInspectionPage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}
