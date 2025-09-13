import 'package:go_router/go_router.dart' show GoRoute;
import 'package:maelys_imo/presentation/portal/pages/portal_detail_page.dart';
import 'package:maelys_imo/presentation/portal/pages/visit_request_page.dart';

import '../presentation/portal/pages/portal_page.dart';
import '../presentation/starter/pages/splash_page.dart';

class StarterRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: SplashPage.routeName,
      path: SplashPage.routePath,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: PortalPage.routeName,
      path: PortalPage.routePath,
      builder: (context, state) => const PortalPage(),
    ),
    GoRoute(
      name: PortalDetailPage.routeName,
      path: PortalDetailPage.routePath,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final type = state.pathParameters['type'];
        return PortalDetailPage(id: id, type: type);
      },
    ),
    GoRoute(
      name: VisitRequestPage.routeName,
      path: VisitRequestPage.routePath,
      builder: (context, state) => const VisitRequestPage(),
    ),
  ];
}
