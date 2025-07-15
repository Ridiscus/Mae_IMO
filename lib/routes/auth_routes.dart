import 'package:go_router/go_router.dart' show GoRoute;

import '../presentation/auth/pages/login_page.dart';
import '../presentation/auth/pages/forget_passord_page.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routePath,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: ForgetPasswordPage.routeName,
      path: ForgetPasswordPage.routePath,
      builder: (context, state) => const ForgetPasswordPage(),
    ),
  ];
}
