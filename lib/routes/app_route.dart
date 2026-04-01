import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/di_container.dart';
import 'package:maelys_imo/presentation/auth/pages/login_page.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/presentation/portal/pages/visit_request_page.dart';
import 'package:maelys_imo/presentation/starter/pages/splash_page.dart';
import 'package:maelys_imo/routes/agent_routes.dart';
import 'package:maelys_imo/routes/profile_routes.dart';
import 'package:maelys_imo/routes/starter_routes.dart';
import 'package:maelys_imo/routes/tenant_routes.dart';
import 'package:maelys_imo/routes/tenant_shell_routes.dart';

import '../main.dart' show navigatorKey;
import 'auth_routes.dart';
import 'commercial_routes.dart';

/// Observateur personnalisé pour imprimer les changements de route
class RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (kDebugMode) {
      print('🚀 Navigation vers: ${route.settings.name ?? 'Route sans nom'}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (kDebugMode) {
      print(
        '⬅️ Retour de: ${route.settings.name ?? 'Route sans nom'} vers: ${previousRoute?.settings.name ?? 'Route sans nom'}',
      );
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (kDebugMode) {
      print(
        '🔄 Remplacement de: ${oldRoute?.settings.name ?? 'Route sans nom'} par: ${newRoute?.settings.name ?? 'Route sans nom'}',
      );
    }
  }
}

class AppRoute {
  static const String initialRoute = '/';

  GoRouter router = GoRouter(
    initialLocation: initialRoute,
    navigatorKey: navigatorKey,
    observers: [RouteObserver()], // Ajout de l'observateur de route
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    // Exit app when back is pressed on home page
    redirectLimit: 5,
    redirect: (context, state) {
      final authState = getIt<AuthBloc>().state;
      final bool loggedIn = authState.userModel != null;
      final bool isLoggingIn = state.matchedLocation == LoginPage.routePath;

      // Routes qui ne nécessitent pas d'être connecté
      final bool isPublicRoute =
          state.matchedLocation == SplashPage.routePath ||
          state.matchedLocation == LoginPage.routePath ||
          state.matchedLocation == PortalPage.routePath ||
          state.matchedLocation.startsWith('/portal/') || // Portal details
          state.matchedLocation == VisitRequestPage.routePath;

      // Si pas connecté et tente d'accéder à une route privée -> Login
      if (!loggedIn && !isPublicRoute) {
        return LoginPage.routePath;
      }

      // Si connecté et est sur les pages auth -> Dashboard (laissé au LoginPage)
      if (loggedIn && isLoggingIn) {
        return null;
      }

      // Imprimer le chemin de la route dans la console
      if (kDebugMode) {
        print('📍 Route actuelle: ${state.matchedLocation}');
      }

      return null;
    },

    routes: [
      ...StarterRoutes.routes,
      ...AuthRoutes.routes,
      ...TenantShellRoutes
          .routes, // Utilisation des routes shell pour le tenant
      ...TenantRoutes
          .routes, // Garder les routes tenant pour les pages hors shell
      ...AgentRoutes.routes,
      ...CommercialRoutes.routes,
      ...ProfileRoutes.routes,
    ],
  );
}

/// Classe utilitaire pour permettre à GoRouter de réagir aux flux (Stream)
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
