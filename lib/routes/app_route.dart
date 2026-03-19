import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // Exit app when back is pressed on home page
    redirectLimit: 5,
    redirect: (context, state) {
      // Imprimer le chemin de la route dans la console
      if (kDebugMode) {
        print('📍 Route actuelle: ${state.matchedLocation}');
        print('📍 Chemin complet: ${state.fullPath}');
        if (state.pathParameters.isNotEmpty) {
          print('📍 Paramètres: ${state.pathParameters}');
        }
        if (state.uri.queryParameters.isNotEmpty) {
          print('📍 Query params: ${state.uri.queryParameters}');
        }
      }

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
