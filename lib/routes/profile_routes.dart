import 'package:go_router/go_router.dart';

import '../shared/widgets/pages/update_email_page.dart';
import '../shared/widgets/pages/update_password_page.dart';

class ProfileRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      name: UpdateEmailPage.routeName,
      path: UpdateEmailPage.routePath,
      builder: (context, state) => const UpdateEmailPage(),
    ),
    GoRoute(
      name: UpdatePasswordPage.routeName,
      path: UpdatePasswordPage.routePath,
      builder: (context, state) => const UpdatePasswordPage(),
    ),
  ];
}
