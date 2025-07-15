import 'package:go_router/go_router.dart' show GoRoute;

import '../presentation/starter/pages/splash_page.dart';

class StarterRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: SplashPage.routeName,
      path: SplashPage.routePath,
      builder: (context, state) => const SplashPage(),
    ),
  ];
}
