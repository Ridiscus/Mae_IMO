import 'package:go_router/go_router.dart' show GoRoute;

import '../presentation/auth/pages/login_page.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routePath,
      builder: (context, state) => const LoginPage(),
    ),
  ];
}
