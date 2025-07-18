import 'package:go_router/go_router.dart';
import 'package:maelys_imo/routes/agent_routes.dart';
import 'package:maelys_imo/routes/starter_routes.dart';
import 'package:maelys_imo/routes/tenant_routes.dart';

import '../main.dart' show navigatorKey;
import 'auth_routes.dart';

class AppRoute {
  static const String initialRoute = '/';

  GoRouter router = GoRouter(
    initialLocation: initialRoute,
    navigatorKey: navigatorKey,

    // Exit app when back is pressed on home page
    redirectLimit: 5,
    redirect: (context, state) {
      // If we're on the home page and trying to go back, exit the app
      // if (state.matchedLocation == MainHomePage.routePath) {
      // Return null to prevent navigation, which will cause the app to exit
      // when back button is pressed on Android/iOS
      // return null;
      // }
      return null;
    },
    routes: [
      ...StarterRoutes.routes,
      ...AuthRoutes.routes,
      ...TenantRoutes.routes,
      ...AgentRoutes.routes,
    ],
  );
}
