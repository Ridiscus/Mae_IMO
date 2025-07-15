import 'package:go_router/go_router.dart' show GoRoute;
import 'package:maelys_imo/presentation/portal/pages/portal_detail_page.dart';

import '../presentation/auth/pages/login_page.dart';
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
      builder: (context, state) => const PortalDetailPage(),
    ),
  ];
}
